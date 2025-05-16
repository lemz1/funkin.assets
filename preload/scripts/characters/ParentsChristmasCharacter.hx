package characters;

import funkin.play.character.SparrowCharacter;
import funkin.play.character.BaseCharacter;
import funkin.play.PlayState;
import funkin.modding.events.ScriptEvent;

class ParentsChristmasCharacter extends SparrowCharacter
{
  function new()
  {
    super('parents-christmas');
  }

  override function onNoteHit(event:HitNoteScriptEvent)
  {
    if (!event.note.noteData.getMustHitNote() && characterType == CharacterType.DAD)
    {
      // Override the hit note animation.
      switch (event.note.kind)
      {
        case "mom":
          holdTimer = 0;
          this.playSingAnimation(event.note.noteData.getDirection(), false, 'alt');
          return;
      }
    }

    super.onNoteHit(event);
  }
}
