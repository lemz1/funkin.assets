package stages.props;

import funkin.graphics.adobeanimate.FlxAtlasSprite;
import flixel.math.FlxPoint;
import funkin.Conductor;
import funkin.Paths;

class ABotAtlasSprite extends FlxAtlasSprite
{
  public function new(x:Float, y:Float)
  {
    super(x, y, Paths.animateAtlas("characters/abot/abotSystem", "shared"),
      {
        FrameRate: 24.0,
        Reversed: false,
        // ?OnComplete:Void -> Void,
        ShowPivot: false,
        Antialiasing: true,
        ScrollFactor: new FlxPoint(1, 1),
      });
  }
}
