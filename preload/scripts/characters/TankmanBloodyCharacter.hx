package characters;

import funkin.play.character.MultiSparrowCharacter;
import funkin.play.character.BaseCharacter;
import funkin.play.PlayState;
import flixel.FlxG;
import funkin.modding.events.ScriptEvent;

class TankmanBloodyCharacter extends MultiSparrowCharacter
{
  function new()
  {
    super('tankman-bloody');
  }

  var isBloody:Bool = false;

  override function playAnimation(name:String, restart:Bool = false, ignoreOther:Bool = false, reverse:Bool = false)
  {
    if (isBloody)
    {
      super.playAnimation(name + '-bloody', restart, ignoreOther, reverse);
    }
    else
    {
      super.playAnimation(name, restart, ignoreOther, reverse);
    }

    if (name == 'redheadsAnim') isBloody = true;
  }

  override function onSongRetry(event:SongRetryEvent):Void
  {
    super.onSongRetry(event);

    isBloody = false;
  }

  override function onNoteHit(event:HitNoteScriptEvent)
  {
    super.onNoteHit(event);

    if (!event.note.noteData.getMustHitNote() && characterType == CharacterType.DAD)
    {
      // Override the hit note animation.
      switch (event.note.kind)
      {
        case "ugh":
          holdTimer = 0;
          this.playAnimation('ugh', true, true);
          return;
        case "hehPrettyGood":
          holdTimer = 0;
          this.playAnimation('hehPrettyGood', true, true);
          return;
      }
    }
  }
}
