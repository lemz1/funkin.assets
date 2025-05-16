package characters;

import funkin.graphics.adobeanimate.FlxAtlasSprite;
import flixel.FlxG;
import funkin.audio.FunkinSound;
import funkin.play.character.MultiSparrowCharacter;
import funkin.play.character.BaseCharacter;
import funkin.play.GameOverSubState;
import funkin.modding.events.ScriptEvent;

class BoyfriendChristmasCharacter extends MultiSparrowCharacter
{
  function new()
  {
    super('bf-christmas');
  }

  override function onNoteHit(event:HitNoteScriptEvent)
  {
    if (event.eventCanceled)
    {
      // onNoteHit event was cancelled by the gameplay module.
      return;
    }

    if (event.note.noteData.getMustHitNote() && characterType == CharacterType.BF)
    {
      // Override the hit note animation.
      switch (event.note.kind)
      {
        case "censor":
          holdTimer = 0;
          this.playSingAnimation(event.note.noteData.getDirection(), false, 'censor');
          return;
        default:
          super.onNoteHit(event);
      }
    }
  }
}
