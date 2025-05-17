package shaders;

import flixel.addons.display.FlxRuntimeShader;
import funkin.Assets;
import funkin.Paths;

class BuildingEffectShader extends FlxRuntimeShader
{
  var alphaShit:Float = 1.0;

  public var effectSpeed:Float = 1.0;

  public function new(speed:Float = 1.0)
  {
    var fragText:String = Assets.getText(Paths.frag('building'));
    super(fragText);
    this.effectSpeed = speed;
  }

  public function setAlpha(value:Float):Void
  {
    this.alphaShit = value;
    this.setFloat('alphaShit', this.alphaShit);
  }

  public function update(elapsed:Float):Void
  {
    setAlpha(alphaShit + effectSpeed * elapsed);
  }

  public function reset()
  {
    setAlpha(0);
  }
}
