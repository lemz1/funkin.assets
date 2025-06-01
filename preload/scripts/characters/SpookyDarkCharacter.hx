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

class SpookyDarkCharacter extends SparrowCharacter
{
  public function new()
  {
    super('spooky-dark');

    this.ignoreExclusionPref = ["cheer"];
  }

  var normalChar:BaseCharacter;

  override function set_alpha(val:Float):Float
  {
    super.set_alpha(val);
    if (normalChar != null)
    {
      if (val != 1) normalChar.alpha = 1;
      else
        normalChar.alpha = 0;
    }

    return val;
  }

  override function onNoteHit(event:HitNoteScriptEvent)
  {
    super.onNoteHit(event);

    if (!event.note.noteData.getMustHitNote() && characterType == CharacterType.DAD)
    {
      // Override the hit note animation.
      switch (event.note.kind)
      {
        case "cheer":
          holdTimer = 0;
          this.playAnimation('cheer', true, true);
          return;
      }
    }
  }

  override function playAnimation(name:String, restart:Bool = false, ignoreOther:Bool = false, reversed:Bool = false)
  {
    trace('spookyDark.playAnimation(' + name + ', ' + restart + ', ' + ignoreOther + ')');
    super.playAnimation(name, restart, ignoreOther);
    if (normalChar != null)
    {
      normalChar.playAnimation(name, restart, ignoreOther, reversed);
      normalChar.setPosition(this.x, this.y);
    }
  }

  override function onCreate(event:ScriptEvent)
  {
    super.onCreate(event);
    normalChar = CharacterDataParser.fetchCharacter('spooky');
    normalChar.zIndex = 199;
    normalChar.alpha = 0;
    normalChar.flipX = false;
    PlayState.instance.currentStage.add(normalChar);
    PlayState.instance.currentStage.refresh(); // Apply z-index.
  }
}
