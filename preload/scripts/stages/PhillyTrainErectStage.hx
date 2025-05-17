package stages;

import stages.props.PicoDopplegangerSprite;
import stages.props.PicoBloodPool;
import funkin.data.song.SongData;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxRuntimeShader;
import flixel.sound.FlxSound;
import funkin.Conductor;
import funkin.graphics.shaders.AdjustColorShader;
import funkin.play.PlayState;
import funkin.play.stage.Stage;
import funkin.play.character.BaseCharacter;
import funkin.graphics.adobeanimate.FlxAtlasSprite;
import flixel.util.FlxTimer;
import funkin.audio.FunkinSound;
import funkin.data.song.SongRegistry;
import flixel.text.FlxText;
import funkin.input.Controls;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import funkin.Preferences;
import funkin.modding.events.ScriptEvent;
import funkin.Paths;
import shaders.BuildingEffectShader;
import characters.NeneCharacter;

class PhillyTrainErectStage extends Stage
{
  public function new()
  {
    super('phillyTrainErect');
    hasPlayedInGameCutscene = false;
  }

  var LIGHT_COUNT:Int = 5;

  var lightShader:BuildingEffectShader;
  var trainSound:FlxSound;
  var colorShader:AdjustColorShader;
  var cutsceneMusic:FunkinSound;

  var hasPlayedInGameCutscene:Bool = false;
  var cutsceneSkipped:Bool = false;
  var canSkipCutscene:Bool = false;
  var hasPlayedCutscene:Bool = false;

  /**
   * Replay the cutscene after leaving the song.
   */
  override function onCreate(event:ScriptEvent):Void
  {
    super.onCreate(event);

    hasPlayedInGameCutscene = false;
    cutsceneSkipped = false;
    canSkipCutscene = false;
    playerShoots = false;
    explode = true;
  }

  public override function onCountdownStart(event:CountdownScriptEvent):Void
  {
    super.onCountdownStart(event);

    if (!hasPlayedInGameCutscene && PlayState.instance.currentStage.getBoyfriend().characterId == 'pico-playable')
    {
      trace('Pausing countdown to play in game cutscene');

      hasPlayedInGameCutscene = true;

      event.cancel(); // CANCEL THE COUNTDOWN!

      PlayState.instance.camHUD.visible = false;
      doppleGangerCutscene();
    }
    else
    {
      hasPlayedInGameCutscene = true;
      cutsceneSkipped = true;
      canSkipCutscene = true;
    }
  }

  var picoPlayer:PicoDopplegangerSprite;
  var picoOpponent:PicoDopplegangerSprite;
  var bloodPool:PicoBloodPool;
  var cigarette:FlxSprite;
  var skipText:FlxText;

  var playerShoots:Bool;
  var explode:Bool;

  var cutsceneConductor:Conductor;

  var cutsceneTimerManager:FlxTimerManager;

  function doppleGangerCutscene()
  {
    // Disable player input during cutscene, so you can't get a gameover during cutscene
    PlayState.instance.isInCutscene = true;
    @:privateAccess
    skipText = new FlxText(936, 618, 0, 'Skip [ ' + PlayState.instance.controls.getDialogueNameFromToken("CUTSCENE_ADVANCE", true) + ' ]', 20);
    skipText.setFormat(Paths.font('vcr.ttf'), 40, 0xFFFFFFFF, "right", FlxTextBorderStyle.OUTLINE, 0xFF000000);
    skipText.scrollFactor.set();
    skipText.borderSize = 2;
    skipText.alpha = 0;
    add(skipText);

    skipText.cameras = [PlayState.instance.camCutscene];

    cutsceneTimerManager = new FlxTimerManager();

    cutsceneConductor = new Conductor();
    var songMusicData:Null<SongMusicData> = SongRegistry.instance.parseMusicData('cutscene');
    if (songMusicData != null)
    {
      cutsceneConductor.mapTimeChanges(songMusicData.timeChanges);
    }
    cutsceneConductor.onBeatHit.add(onCutsceneBeatHit);

    // 50/50 chance for who shoots
    if (FlxG.random.bool(50))
    {
      playerShoots = true;
    }
    else
    {
      playerShoots = false;
    }
    if (FlxG.random.bool(8))
    {
      // trace('Doppelganger will explode!');
      explode = true;
    }
    else
    {
      // trace('Doppelganger will smoke!');
      explode = false;
    }

    var cigarettePos:Array<Float> = [];
    var shooterPos:Array<Float> = [];

    bloodPool = new PicoBloodPool(0, 0);
    picoPlayer = new PicoDopplegangerSprite(0, 0);
    picoOpponent = new PicoDopplegangerSprite(0, 0);
    cigarette = new FlxSprite(0, 0);

    picoPlayer.setPosition(PlayState.instance.currentStage.getBoyfriend().x + 48.5, PlayState.instance.currentStage.getBoyfriend().y + 400);
    picoOpponent.setPosition(PlayState.instance.currentStage.getDad().x + 82, PlayState.instance.currentStage.getDad().y + 400);

    picoPlayer.zIndex = PlayState.instance.currentStage.getBoyfriend().zIndex + 1;

    if (playerShoots == true)
    {
      picoOpponent.zIndex = picoPlayer.zIndex - 1;
      bloodPool.zIndex = picoOpponent.zIndex - 1;
      cigarette.zIndex = PlayState.instance.currentStage.getBoyfriend().zIndex - 2;
      cigarette.flipX = true;

      cigarette.setPosition(PlayState.instance.currentStage.getBoyfriend().x - 143.5, PlayState.instance.currentStage.getBoyfriend().y + 210);
      bloodPool.setPosition(PlayState.instance.currentStage.getDad().x - 1487, PlayState.instance.currentStage.getDad().y - 173);

      shooterPos = [
        PlayState.instance.currentStage.getBoyfriend().cameraFocusPoint.x,
        PlayState.instance.currentStage.getBoyfriend().cameraFocusPoint.y
      ];
      cigarettePos = [
        PlayState.instance.currentStage.getDad().cameraFocusPoint.x,
        PlayState.instance.currentStage.getDad().cameraFocusPoint.y
      ];
    }
    else
    {
      picoOpponent.zIndex = picoPlayer.zIndex + 1;
      bloodPool.zIndex = picoPlayer.zIndex - 1;
      cigarette.zIndex = PlayState.instance.currentStage.getDad().zIndex - 2;

      bloodPool.setPosition(PlayState.instance.currentStage.getBoyfriend().x - 788.5, PlayState.instance.currentStage.getBoyfriend().y - 173);
      cigarette.setPosition(PlayState.instance.currentStage.getBoyfriend().x - 478.5, PlayState.instance.currentStage.getBoyfriend().y + 205);

      cigarettePos = [
        PlayState.instance.currentStage.getBoyfriend().cameraFocusPoint.x,
        PlayState.instance.currentStage.getBoyfriend().cameraFocusPoint.y
      ];
      shooterPos = [
        PlayState.instance.currentStage.getDad().cameraFocusPoint.x,
        PlayState.instance.currentStage.getDad().cameraFocusPoint.y
      ];
    }
    var midPoint:Array<Float> = [(shooterPos[0] + cigarettePos[0]) / 2, (shooterPos[1] + cigarettePos[1]) / 2];

    cigarette.frames = Paths.getSparrowAtlas('philly/erect/cigarette');
    cigarette.animation.addByPrefix('cigarette spit', 'cigarette spit', 24, false);
    cigarette.visible = false;

    PlayState.instance.currentStage.add(cigarette);
    PlayState.instance.currentStage.add(picoPlayer);
    PlayState.instance.currentStage.add(picoOpponent);
    PlayState.instance.currentStage.add(bloodPool);
    PlayState.instance.currentStage.refresh();

    picoPlayer.shader = colorShader;
    picoOpponent.shader = colorShader;
    bloodPool.shader = colorShader;

    PlayState.instance.currentStage.getBoyfriend().visible = false;
    PlayState.instance.currentStage.getDad().visible = false;

    if (explode == false)
    {
      cutsceneMusic = FunkinSound.load(Paths.music("cutscene/cutscene", "week3"), true);
    }
    else
    {
      cutsceneMusic = FunkinSound.load(Paths.music("cutscene/cutscene2", "week3"), true);
    }
    cutsceneMusic.volume = 1;
    cutsceneMusic.play(false);

    picoPlayer.doAnim('Player', playerShoots, explode, cutsceneTimerManager);
    picoOpponent.doAnim('Opponent', !playerShoots, explode, cutsceneTimerManager);

    FunkinSound.playOnce(Paths.sound('cutscene/picoGasp'), 1);

    PlayState.instance.resetCamera(false, true);
    PlayState.instance.cameraFollowPoint.setPosition(midPoint[0], midPoint[1]);

    new FlxTimer(cutsceneTimerManager).start(4, _ -> {
      PlayState.instance.cameraFollowPoint.setPosition(cigarettePos[0], cigarettePos[1]);
    });

    new FlxTimer(cutsceneTimerManager).start(6.3, _ -> {
      PlayState.instance.cameraFollowPoint.setPosition(shooterPos[0], shooterPos[1]);
    });

    new FlxTimer(cutsceneTimerManager).start(8.75, _ -> {
      cutsceneSkipped = true;
      canSkipCutscene = false;
      FlxTween.tween(skipText, {alpha: 0}, 0.5,
        {
          ease: FlxEase.quadIn,
          onComplete: _ -> {
            skipText.visible = false;
          }
        });
      // cutting off skipping here. really dont think its needed after this point and it saves problems from happening
      PlayState.instance.cameraFollowPoint.setPosition(cigarettePos[0], cigarettePos[1]);
      if (explode == true) PlayState.instance.currentStage.getGirlfriend().playAnimation('drop70', true);
    });

    new FlxTimer(cutsceneTimerManager).start(11.2, _ -> {
      if (explode == true) bloodPool.doAnim();
    });

    new FlxTimer(cutsceneTimerManager).start(11.5, _ -> {
      if (explode == false)
      {
        cigarette.visible = true;
        cigarette.animation.play('cigarette spit');
      }
    });

    new FlxTimer(cutsceneTimerManager).start(13, _ -> {
      if (explode == false || playerShoots == true)
      {
        PlayState.instance.startCountdown();
      }

      if (explode == true)
      {
        if (playerShoots == true)
        {
          picoPlayer.visible = false;
          PlayState.instance.currentStage.getBoyfriend().visible = true;
        }
        else
        {
          picoOpponent.visible = false;
          PlayState.instance.disableKeys = true;
          PlayState.instance.currentStage.getDad().visible = true;

          new FlxTimer().start(1, function(tmr) {
            PlayState.instance.camCutscene.fade(0xFF000000, 1, false, null, true);
          });

          new FlxTimer().start(2, function(tmr) {
            PlayState.instance.camCutscene.fade(0xFF000000, 0.5, true, null, true);
            PlayState.instance.endSong(true);
          });
        }
      }
      else
      {
        picoPlayer.visible = false;
        PlayState.instance.currentStage.getBoyfriend().visible = true;
        picoOpponent.visible = false;
        PlayState.instance.currentStage.getDad().visible = true;
      }

      hasPlayedCutscene = true;
      cutsceneMusic.stop();
    });
  }

  function skipCutscene()
  {
    cutsceneSkipped = true;
    explode = false;
    hasPlayedCutscene = true;
    PlayState.instance.camCutscene.fade(0xFF000000, 0.5, false, null, true);
    cutsceneMusic.fadeOut(0.5, 0);

    new FlxTimer().start(0.5, _ -> {
      @:privateAccess
      PlayState.instance.justUnpaused = true;
      PlayState.instance.camCutscene.fade(0xFF000000, 0.5, true, null, true);

      cutsceneTimerManager.clear();
      picoPlayer.cancelSounds();
      picoOpponent.cancelSounds();
      cutsceneMusic.stop();

      PlayState.instance.startCountdown();

      skipText.visible = false;
      picoPlayer.visible = false;
      picoOpponent.visible = false;
      PlayState.instance.currentStage.getBoyfriend().visible = true;
      PlayState.instance.currentStage.getDad().visible = true;
    });
  }

  function onCutsceneBeatHit()
  {
    if (PlayState.instance.currentStage.getGirlfriend().isAnimationFinished())
    {
      PlayState.instance.currentStage.getGirlfriend().dance(true);
    }
  }

  override function onNoteHit(event:HitNoteScriptEvent)
  {
    super.onNoteHit(event);
    if (PlayState.instance.currentStage == null) return;
    if (!event.note.noteData.getMustHitNote() && explode == true && playerShoots == true)
    {
      event.cancelEvent();
      PlayState.instance.vocals.opponentVolume = 0;
    }
  }

  override function buildStage()
  {
    super.buildStage();

    // NOTE: You pass the constructor variables directly, not as an array.
    lightShader = new BuildingEffectShader(1.0);
    trainSound = new FlxSound().loadEmbedded(Paths.sound('train_passes'));

    colorShader = new AdjustColorShader();
    colorShader.hue = -26;
    colorShader.saturation = -16;
    colorShader.contrast = 0;
    colorShader.brightness = -5;
    getNamedProp('train').shader = colorShader;

    FlxG.sound.list.add(trainSound);

    for (i in 0...LIGHT_COUNT)
    {
      var light:FlxSprite = getNamedProp('lights' + i);
      light.shader = lightShader;
      light.visible = false;
    }
  }

  override function fetchAssetPaths():Array<String>
  {
    var results:Array<String> = super.fetchAssetPaths();
    results.push(Paths.sound('train_passes'));
    return results;
  }

  var trainMoving:Bool = false;
  var trainFrameTiming:Float = 0;
  var trainCars:Int = 8;
  var trainFinishing:Bool = false;
  var trainCooldown:Int = 0;

  override function onUpdate(event:UpdateScriptEvent):Void
  {
    super.onUpdate(event);
    if (cutsceneTimerManager != null) cutsceneTimerManager.update(event.elapsed);
    // Update beat lights
    var shaderInput:Float = (Conductor.instance.beatLengthMs / 1000) * event.elapsed * 1.5;
    lightShader.update(shaderInput);

    var amount:Int = 1;

    // Update train
    if (trainMoving)
    {
      trainFrameTiming += event.elapsed;

      if (trainFrameTiming >= 1 / 24)
      {
        updateTrainPos();
        trainFrameTiming = 0;
      }
    }
    @:privateAccess
    if (PlayState.instance.controls.CUTSCENE_ADVANCE && cutsceneSkipped == false)
    {
      if (canSkipCutscene == false)
      {
        trace('cant skip yet!');
        FlxTween.tween(skipText, {alpha: 1}, 0.5, {ease: FlxEase.quadOut});
        new FlxTimer().start(0.5, _ -> {
          canSkipCutscene = true;
          trace('can skip!');
        });
      }
    }
    @:privateAccess
    if (PlayState.instance.controls.CUTSCENE_ADVANCE && cutsceneSkipped == false && canSkipCutscene == true)
    {
      skipCutscene();
      trace('skipped');
    }

    if (cutsceneConductor != null && cutsceneMusic != null)
    {
      cutsceneConductor.update(cutsceneMusic.time);
    }
  }

  override function addCharacter(character:BaseCharacter, charType:CharacterType):Void
  {
    // Apply the shader automatically to each character as it gets added.
    super.addCharacter(character, charType);
    trace('Applied stage shader to ' + character.characterName);

    shader = new AdjustColorShader();

    cast(shader, AdjustColorShader).hue = -26;
    cast(shader, AdjustColorShader).saturation = -16;
    cast(shader, AdjustColorShader).contrast = 0;
    cast(shader, AdjustColorShader).brightness = -5;

    character.shader = shader;
  }

  override function onBeatHit(event:SongTimeScriptEvent):Void
  {
    super.onBeatHit(event);
    // Update train cooldown
    if (!trainMoving) trainCooldown += 1;

    // Start train
    if (event.beat % 8 == 4 && FlxG.random.bool(30) && !trainMoving && trainCooldown > 8)
    {
      trainCooldown = FlxG.random.int(-4, 0);
      trainStart();
    }

    // Update lights
    if (event.beat % 4 == 0)
    {
      // Reset opacity
      lightShader.reset();

      // Switch to a different light
      var curLight = FlxG.random.int(0, LIGHT_COUNT - 1);
      for (i in 0...LIGHT_COUNT)
      {
        getNamedProp('lights' + i).visible = (i == curLight);
      }
    }
  }

  function trainStart():Void
  {
    trainMoving = true;
    trainSound.play(true);
  }

  var startedMoving:Bool = false;

  function updateTrainPos():Void
  {
    if (trainSound.time >= 4700)
    {
      startedMoving = true;
      switch (getGirlfriend().characterId)
      {
        case 'nene':
          cast(getGirlfriend(), NeneCharacter).trainPassing = true;
        default:
          getGirlfriend().playAnimation('hairBlow');
      }
    }

    if (startedMoving)
    {
      var train:FlxSprite = getNamedProp('train');
      train.x -= 400;

      if (train.x < -2000 && !trainFinishing)
      {
        train.x = -1150;
        trainCars -= 1;

        if (trainCars <= 0) trainFinishing = true;
      }

      if (train.x < -4000 && trainFinishing) trainReset();
    }
  }

  function trainReset():Void
  {
    getNamedProp('train').x = FlxG.width + 200;

    switch (getGirlfriend().characterId)
    {
      case 'nene':
        cast(getGirlfriend(), NeneCharacter).trainPassing = false;
      default:
        getGirlfriend().playAnimation('hairFall');
    }

    trainMoving = false;
    trainCars = 8;
    trainFinishing = false;
    startedMoving = false;
  }

  override function kill()
  {
    super.kill();
    if (cutsceneTimerManager != null) cutsceneTimerManager.destroy();
    lightShader = null;
  }
}
