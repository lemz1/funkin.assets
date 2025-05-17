package characters;

import funkin.graphics.adobeanimate.FlxAtlasSprite;
import flixel.FlxG;
import funkin.audio.FunkinSound;
import funkin.play.character.SparrowCharacter;
import funkin.play.GameOverSubState;
import funkin.play.character.BaseCharacter;
import funkin.play.character.CharacterData;
import funkin.play.character.BaseCharacter;
import funkin.play.PlayState;
import funkin.modding.events.ScriptEvent;

class GirlfriendDarkCharacter extends SparrowCharacter
{
  public function new()
  {
    super('gf-dark');
  }

  var normalChar:BaseCharacter;

  override function set_alpha(val:Float):Float
  {
    super.set_alpha(val);
    if (val != 1) normalChar.alpha = 1;
    else
      normalChar.alpha = 0;

    return val;
  }

  override function playAnimation(name:String, restart:Bool = false, ignoreOther:Bool = false, reversed:Bool = false)
  {
    super.playAnimation(name, restart, ignoreOther, reversed);
    if (normalChar != null)
    {
      normalChar.playAnimation(name, restart, ignoreOther, reversed);
      normalChar.setPosition(this.x, this.y);
    }
  }

  override function onCreate(event:ScriptEvent)
  {
    super.onCreate(event);
    normalChar = CharacterDataParser.fetchCharacter('gf');
    normalChar.zIndex = 99;
    normalChar.alpha = 0;
    normalChar.flipX = false;

    PlayState.instance.currentStage.add(normalChar);
    PlayState.instance.currentStage.refresh(); // Apply z-index.
  }
}
