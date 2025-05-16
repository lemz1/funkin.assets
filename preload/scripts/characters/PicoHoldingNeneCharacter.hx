package characters;

import funkin.play.character.SparrowCharacter;
import funkin.play.character.BaseCharacter;
import funkin.play.PlayState;
import funkin.play.GameOverSubState;
import funkin.graphics.adobeanimate.FlxAtlasSprite;
import flixel.util.FlxTimer;
import funkin.graphics.FunkinSprite;
import funkin.audio.FunkinSound;
import flixel.FlxSprite;
import flixel.FlxG;
import funkin.modding.base.ScriptedFunkinSprite;
import flixel.group.FlxSpriteGroup;
import flixel.effects.FlxFlicker;
import funkin.play.PauseSubState;
import funkin.modding.module.ModuleHandler;
import flixel.tweens.FlxTween;
import funkin.Preferences;
import funkin.modding.events.ScriptEvent;
import funkin.Paths;

class PicoHoldingNeneCharacter extends SparrowCharacter
{
  function new()
  {
    super('pico-holding-nene');
  }

  override function onCreate(event:ScriptEvent)
  {
    super.onCreate(event);

    // NOTE: this.x and this.y are not properly set here.

    GameOverSubState.musicSuffix = '-pico';
    GameOverSubState.blueBallSuffix = '-pico-and-nene';

    PauseSubState.musicSuffix = '-pico';
  }

  override function onSongRetry(event:SongRetryEvent):Void
  {
    super.onSongRetry(event);

    // Reset to standard death animation.
    GameOverSubState.musicSuffix = '-pico';
    GameOverSubState.blueBallSuffix = '-pico-and-nene';

    PauseSubState.musicSuffix = '-pico';

    this.visible = true;
  }

  var deathSpriteRetry:FlxAtlasSprite;

  /**
     * Initialize and cache sprites used for the death animation,
   * for use later.
   */
  function createDeathSprites()
  {
    deathSpriteRetry = new FlxAtlasSprite(this.x + 15, this.y + 39, Paths.animateAtlas("characters/picoAndNene-DEAD", "shared"));
    deathSpriteRetry.zIndex = 1000;
  }

  override function onUpdate(event:UpdateScriptEvent):Void
  {
    super.onUpdate(event);
  }

  function addToStage(sprite:FlxSprite)
  {
    if (this.debug)
    {
      // We are in the chart editor or something.
      // TODO: Make this work properly.
    }
    else if (PlayState.instance != null && PlayState.instance.currentStage != null)
    {
      PlayState.instance.currentStage.add(sprite);
    }
    else
    {
      trace('Could not add Pico sprite to stage.');
    }
  }

  override function playAnimation(name:String, restart:Bool = false, ignoreOther:Bool = false, reversed:Bool = false)
  {
    if (name == "firstDeath")
    {
      new FlxTimer().start(0.58, afterPicoDeathNeneIntro);

      createDeathSprites();
      GameOverSubState.instance.add(deathSpriteRetry);
      this.visible = false;
      deathSpriteRetry.onAnimationComplete.add(onAnimationComplete);
      deathSpriteRetry.playAnimation("intro", true, false, false);
    }
    else if (name == "deathConfirm")
    {
      doDeathConfirm();
    }
    else
    {
      super.playAnimation(name, restart, ignoreOther, reversed);
    }

    super.playAnimation(name, restart, ignoreOther, reversed);
  }

  function afterPicoDeathNeneIntro(_:Null<FlxTimer>):Void
  {
    // Delay the death quote because the first death animation is so fast.
    new FlxTimer().start(1.5, function(_) {
      // Prevent playing the death quote twice or if skipping the death animation.
      @:privateAccess
      if (GameOverSubState.instance.hasPlayedDeathQuote) return;

      @:privateAccess
      GameOverSubState.instance.playDeathQuote();
    });
  }

  function onAnimationComplete(currentAnim:String):Void
  {
    if (currentAnim == "confirm")
    {
      deathSpriteRetry.playAnimation("confirm", true, false, true);
    }
    else
    {
      deathSpriteRetry.playAnimation("loop", true, false, true);
    }
  }

  function doDeathConfirm():Void
  {
    deathSpriteRetry.playAnimation("confirm", true, false, true);
  }

  override function getDeathQuote():Null<String>
  {
    var randomCensor:Array<Int> = [];

    if (!Preferences.naughtyness) randomCensor = [];

    return Paths.sound('jeffGameover-pico/jeffGameover-' + FlxG.random.int(1, 10, randomCensor));
  }
}
