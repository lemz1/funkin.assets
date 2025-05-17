package stages;

import funkin.play.PlayState;
import funkin.play.stage.Stage;
import funkin.modding.events.ScriptEvent;
import funkin.Paths;
import funkin.play.stage.Bopper;

class SchoolStage extends Stage
{
  public function new()
  {
    super('school');
  }

  override function buildStage()
  {
    super.buildStage();

    if (PlayState.instance.currentSong.id.toLowerCase() == "roses")
    {
      cast(getNamedProp('freaks'), Bopper).idleSuffix = '-scared';
    }
    else
    {
      cast(getNamedProp('freaks'), Bopper).idleSuffix = '';
    }
  }
}
