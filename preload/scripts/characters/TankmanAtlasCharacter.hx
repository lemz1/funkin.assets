package characters;

import funkin.play.character.AnimateAtlasCharacter;
import funkin.play.character.BaseCharacter;
import funkin.play.PlayState;
import funkin.modding.events.ScriptEvent;

/**
 * A prototype variant of Tankman that uses the Adobe Animate Texture Atlas animation system.
 */
class TankmanAtlasCharacter extends AnimateAtlasCharacter
{
  public function new()
  {
    super('tankman-atlas');
  }

  override function onNoteHit(event:HitNoteScriptEvent)
  {
    if (!event.note.noteData.getMustHitNote() && characterType == CharacterType.DAD)
    {
      // Override the hit note animation.
      switch (event.note.kind)
      {
        case "ugh":
          holdTimer = 0;
          // CPPIA: This function just straight up doesn't exist???
          // this.playAnimFbfation('ugh');
          return;
        case "hehPrettyGood":
          holdTimer = 0;
          this.playAnimation('hehPrettyGood');
          return;
      }
    }

    super.onNoteHit(event);
  }
}
