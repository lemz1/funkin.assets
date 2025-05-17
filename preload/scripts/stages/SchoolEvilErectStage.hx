package stages;

import funkin.play.PlayState;
import funkin.play.stage.Stage;
import funkin.graphics.shaders.WiggleEffectRuntime;
import flixel.addons.effects.FlxTrail;
import funkin.play.Countdown;
import funkin.modding.events.ScriptEvent;
import flixel.addons.display.FlxRuntimeShader;
import funkin.play.character.BaseCharacter;
import funkin.Paths;

class SchoolEvilErectStage extends Stage
{
  public function new()
  {
    super('schoolEvilErect');
  }

  var wiggle:WiggleEffectRuntime = null;

  override function buildStage()
  {
    super.buildStage();

    wiggle = new WiggleEffectRuntime(2, 4, 0.017, WiggleEffectType.DREAMY);

    getNamedProp('evilSchoolBG').shader = wiggle;
  }

  override function addCharacter(char:BaseCharacter, charType:CharacterType)
  {
    super.addCharacter(char, charType);
  }

  override function onUpdate(event:UpdateScriptEvent)
  {
    super.onUpdate(event);

    if (wiggle != null)
    {
      wiggle.update(event.elapsed);
    }
  }

  override function kill()
  {
    super.kill();
    wiggle = null;
  }
}
