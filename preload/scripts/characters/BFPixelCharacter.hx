package characters;

import funkin.play.character.MultiSparrowCharacter;
import funkin.play.PlayState;
import funkin.play.GameOverSubState;
import funkin.play.PauseSubState;
import flixel.FlxSprite;
import flixel.FlxG;
import funkin.modding.events.ScriptEvent;

class BFPixelCharacter extends MultiSparrowCharacter
{
  public function new()
  {
    super('bf-pixel');
  }

  override function onCreate(event:ScriptEvent)
  {
    super.onCreate(event);

    GameOverSubState.musicSuffix = '-pixel';
    GameOverSubState.blueBallSuffix = '-pixel';

    PauseSubState.musicSuffix = '-pixel';
  }

  override function playAnimation(name:String, restart:Bool = false, ignoreOther:Bool = false, reverse:Bool = false)
  {
    if (name == "firstDeath")
    {
      this.shader = null;
    }

    super.playAnimation(name, restart, ignoreOther, reverse);
  }
}
