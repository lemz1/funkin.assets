package characters;

import funkin.play.character.PackerCharacter;
import funkin.play.PlayState;
import flixel.addons.effects.FlxTrail;
import funkin.effects.FunkTrail;
import funkin.modding.events.ScriptEvent;
import flixel.FlxSprite;
import flixel.FlxG;

class SpiritCharacter extends PackerCharacter
{
  function new()
  {
    super('spirit');
  }

  override function onCreate(event:ScriptEvent)
  {
    super.onCreate(event);

    // Weird workaround because `this` is a PolymodScriptClass and not a ScriptedPackerCharacter. (this.superClass)
    // CPPIA: In CPPIA this is not a problem
    var evilTrail = new FunkTrail(this, null, 4, 24, 0.3, 0.069);

    // Go behind Spirit.
    evilTrail.zIndex = 190;
    addToStage(evilTrail);
  }

  function addToStage(sprite:FlxSprite)
  {
    if (this.debug)
    {
      // We are in the chart editor or something.
      // CPPIA: This was FlxG.stage before? - I assume that was a typo
      FlxG.state.add(sprite);
    }
    else
    {
      PlayState.instance.currentStage.add(sprite);
    }
  }
}
