package shaders;

import flixel.addons.display.FlxRuntimeShader;
import funkin.Assets;
import funkin.Paths;

class InvertColorShader extends FlxRuntimeShader
{
  public function new()
  {
    var fragText:String = Assets.getText(Paths.frag('invertColor'));
    super(fragText);
  }
}
