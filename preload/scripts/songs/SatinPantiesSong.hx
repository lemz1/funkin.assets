package songs;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import funkin.audio.FunkinSound;
import funkin.Conductor;
import funkin.graphics.adobeanimate.FlxAtlasSprite;
import funkin.graphics.FunkinSprite;
import funkin.play.cutscene.VideoCutscene;
import funkin.play.cutscene.VideoCutscene;
import funkin.play.GameOverSubState;
import funkin.play.PlayState;
import funkin.play.PlayStatePlaylist;
import funkin.play.song.Song;
import funkin.play.stage.StageProp;
import funkin.save.Save;
import funkin.modding.events.ScriptEvent;

class SatinPantiesSong extends Song
{
  public function new()
  {
    super('satin-panties');
  }
}
