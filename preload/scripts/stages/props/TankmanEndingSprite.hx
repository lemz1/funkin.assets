package stages.props;

import funkin.graphics.adobeanimate.FlxAtlasSprite;
import flixel.math.FlxPoint;
import flixel.FlxSprite;
import funkin.graphics.FunkinSprite;
import funkin.play.PlayState;
import flixel.util.FlxTimer;
import flixel.FlxG;
import funkin.audio.FunkinSound;
import funkin.Paths;

class TankmanEndingSprite extends FlxAtlasSprite
{
  public function new(x:Float, y:Float)
  {
    super(x, y, Paths.animateAtlas("erect/cutscene/tankmanEnding", "week7"),
      {
        FrameRate: 24.0,
        Reversed: false,
        // ?OnComplete:Void -> Void,
        ShowPivot: false,
        Antialiasing: true,
        ScrollFactor: new FlxPoint(1, 1),
      });
  }

  var cutsceneSounds:FunkinSound = null;

  public function cancelSounds()
  {
    if (cutsceneSounds != null) cutsceneSounds.destroy();
  }

  public function doAnim()
  {
    playAnimation("tankman stress ending", true, false, false);
    cutsceneSounds = FunkinSound.load(Paths.sound('erect/endCutscene'), 1.0, false, true, true);
  }
}
