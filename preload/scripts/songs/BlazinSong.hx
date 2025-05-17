package songs;

import flixel.FlxG;
import funkin.play.song.Song;
import funkin.play.PlayState;
import funkin.graphics.FunkinSprite;
import funkin.play.cutscene.VideoCutscene;
import funkin.play.PlayStatePlaylist;
import funkin.save.Save;
import funkin.modding.events.ScriptEvent;
import funkin.Paths;

/**
 * Apply middlescroll to the song.
 */
class BlazinSong extends Song
{
  public function new()
  {
    super('blazin');

    this.hasHidden = false;
    this.hasPlayedCutscene = false;
  }

  override function onCreate(event:ScriptEvent):Void
  {
    super.onCreate(event);

    this.hasHidden = false;
    this.hasPlayedCutscene = false;
  }

  override function onDestroy(event:ScriptEvent):Void
  {
    super.onDestroy(event);

    this.hasHidden = false;
  }

  override function onNoteHit(event:HitNoteScriptEvent):Void
  {
    super.onNoteHit(event);
  }

  public override function listDifficulties(?variationId:String, ?variationIds:Array<String>, showLocked:Bool = false, showHidden:Bool = false):Array<String>
  {
    if (showLocked || Save.instance.hasBeatenLevel('weekend1'))
    {
      return super.listDifficulties(variationId, variationIds);
    }

    // Hide all difficulties if the player has not beaten the week.
    return [];
  }

  var hasHidden = false;
  var hasPlayedCutscene:Bool = false;

  override function onUpdate(event:UpdateScriptEvent):Void
  {
    super.onUpdate(event);

    if (!this.hasHidden)
    {
      this.hasHidden = true;
      hideOpponentStrumline();
      centerPlayerStrumline();
    }
  }

  function hideOpponentStrumline()
  {
    var opponentStrumline = PlayState.instance.opponentStrumline;
    if (opponentStrumline != null)
    {
      for (arrow in opponentStrumline.members)
      {
        arrow.visible = false;
      }
    }
  }

  function centerPlayerStrumline()
  {
    // This is a song gimmick we are never making middlescroll an option.

    var playerStrumline = PlayState.instance.playerStrumline;
    if (playerStrumline != null)
    {
      playerStrumline.x = FlxG.width / 2 - playerStrumline.width / 2;
    }
  }

  public override function onSongEnd(event:ScriptEvent):Void
  {
    super.onSongEnd(event);

    // Keep the cutscene from playing outside of story mode.
    if (!PlayStatePlaylist.isStoryMode) hasPlayedCutscene = true;

    if (!hasPlayedCutscene)
    {
      trace('Pausing ending to play a video cutscene (`blazin`)');

      hasPlayedCutscene = true;

      // Add a black background behind the cutscene to fix a transition bug!
      trace('Adding black background behind cutscene over UI');
      var bgSprite = new FunkinSprite(-100, -100);
      bgSprite.makeSolidColor(2000, 2500, 0xFF000000);
      bgSprite.cameras = [PlayState.instance.camHUD]; // Show over the HUD.
      bgSprite.zIndex = 1000000;
      PlayState.instance.add(bgSprite);
      PlayState.instance.refresh();

      event.cancel(); // CANCEL THE COUNTDOWN!

      startVideo();
    }
    else
    {
      // Make sure the cutscene can play again next time!
      hasPlayedCutscene = false;
      // DO NOT CANCEL THE EVENT!
    }
  }

  function startVideo()
  {
    VideoCutscene.play(Paths.videos('blazinCutscene'), CutsceneType.ENDING);
    // This will call onSongEnd() again so make sure the flag is set!
    hasPlayedCutscene = true;
  }
}
