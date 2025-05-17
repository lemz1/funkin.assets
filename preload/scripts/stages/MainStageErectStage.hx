package stages;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxRuntimeShader;
import flixel.sound.FlxSound;
import funkin.Conductor;
import funkin.graphics.shaders.AdjustColorShader;
import funkin.play.PlayState;
import funkin.play.stage.Stage;
import funkin.graphics.adobeanimate.FlxAtlasSprite;
import funkin.modding.events.ScriptEvent;
import funkin.Paths;

class MainStageErectStage extends Stage
{
  public function new()
  {
    super('mainStageErect');
  }

  var colorShaderBf:AdjustColorShader;
  var colorShaderDad:AdjustColorShader;
  var colorShaderGf:AdjustColorShader;

  public override function onCountdownStart(event:CountdownScriptEvent):Void
  {
    super.onCountdownStart(event);
  }

  override function buildStage()
  {
    super.buildStage();

    colorShaderBf = new AdjustColorShader();
    colorShaderDad = new AdjustColorShader();
    colorShaderGf = new AdjustColorShader();

    colorShaderBf.brightness = -23;
    colorShaderBf.hue = 12;
    colorShaderBf.contrast = 7;
    colorShaderBf.saturation = 0;

    colorShaderGf.brightness = -30;
    colorShaderGf.hue = -9;
    colorShaderGf.contrast = -4;
    colorShaderGf.saturation = 0;

    colorShaderDad.brightness = -33;
    colorShaderDad.hue = -32;
    colorShaderDad.contrast = -23;
    colorShaderDad.saturation = 0;

    getNamedProp('brightLightSmall').blend = ADD;
    getNamedProp('orangeLight').blend = ADD;
    getNamedProp('lightgreen').blend = ADD;
    getNamedProp('lightred').blend = ADD;
    getNamedProp('lightAbove').blend = ADD;
  }

  override function onUpdate(event:UpdateScriptEvent):Void
  {
    super.onUpdate(event);

    if (PlayState.instance.currentStage.getBoyfriend() != null && PlayState.instance.currentStage.getBoyfriend().shader == null)
    {
      PlayState.instance.currentStage.getBoyfriend().shader = colorShaderBf;
      PlayState.instance.currentStage.getGirlfriend().shader = colorShaderGf;
      PlayState.instance.currentStage.getDad().shader = colorShaderDad;
    }
  }

  override function onBeatHit(event:SongTimeScriptEvent):Void
  {
    super.onBeatHit(event);
  }

  override function onStepHit(event:SongTimeScriptEvent):Void
  {
    super.onStepHit(event);
  }
}
