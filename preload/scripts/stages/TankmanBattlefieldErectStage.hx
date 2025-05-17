package stages;

import flixel.FlxG;
import flixel.math.FlxAngle;
import funkin.play.PlayState;
import funkin.play.stage.Stage;
import funkin.play.stage.Bopper;
import funkin.graphics.shaders.DropShadowShader;
import funkin.play.character.BaseCharacter;
import openfl.display.BitmapData;
import flixel.graphics.FlxGraphic;
import funkin.modding.events.ScriptEvent;

class TankmanBattlefieldErectStage extends Stage
{
  public function new()
  {
    super('tankmanBattlefieldErect');
  }

  override function onCreate(event:ScriptEvent):Void
  {
    super.onCreate(event);
  }

  var tankmanRim:DropShadowShader;

  override function onGameOver(event:ScriptEvent)
  {
    super.onGameOver(event);
    getBoyfriend().shader = null;
  }

  override function addCharacter(character:BaseCharacter, charType:CharacterType):Void
  {
    // Apply the shader automatically to each character as it gets added.
    super.addCharacter(character, charType);
    trace('Applied stage shader to ' + character.characterName);

    var rim = new DropShadowShader();
    rim.setAdjustColor(-46, -38, -25, -20);
    rim.color = 0xFFDFEF3C;
    character.shader = rim;
    rim.attachedSprite = character;

    switch (charType)
    {
      case CharacterType.BF:
        rim.angle = 90;

        character.animation.onFrameChange.add(function(_, _, _) {
          if (getBoyfriend() != null)
          {
            rim.updateFrameInfo(getBoyfriend().frame);
          }
        });

      case CharacterType.GF:
        rim.angle = 90;

        character.animation.onFrameChange.add(function(_, _, _) {
          rim.updateFrameInfo(getGirlfriend().frame);
        });

        if (getGirlfriend().characterId == 'gf-tankmen')
        {
          rim.loadAltMask('assets/week7/images/erect/masks/gfTankmen_mask.png');
          rim.maskThreshold = 0.4;
          rim.useAltMask = true;
        }

      case CharacterType.DAD:
        rim.angle = 135;
        rim.threshold = 0.3;

        character.animation.onFrameChange.add(function(_, _, _) {
          rim.updateFrameInfo(getDad().frame);
        });

        if (getDad().characterId == 'tankman-bloody')
        {
          rim.loadAltMask('assets/week7/images/erect/masks/tankmanCaptainBloody_mask.png');
          rim.maskThreshold = 1;
          rim.useAltMask = false;
        }

        // need to save this for later for when the mask is needed
        tankmanRim = rim;

      default:
    }
  }

  /**
   * Called when the chart hits a song event.
   */
  public override function onSongEvent(scriptEvent:SongEventScriptEvent)
  {
    super.onSongEvent(scriptEvent);

    if (scriptEvent.eventData.eventKind == "EnableMask" && tankmanRim != null)
    {
      tankmanRim.useAltMask = true;
    }
  }

  override function buildStage()
  {
    super.buildStage();
  }

  override function onUpdate(event:UpdateScriptEvent):Void
  {
    super.onUpdate(event);
  }

  override function onBeatHit(event:SongTimeScriptEvent):Void
  {
    super.onBeatHit(event);

    if (FlxG.random.bool(2))
    {
      cast(getNamedProp('sniper'), Bopper).playAnimation('sip', false, true);
    }
  }

  override function onSongRetry(event:SongRetryEvent)
  {
    super.onSongRetry(event);

    if (tankmanRim != null)
    {
      tankmanRim.useAltMask = false;
    }
  }
}
