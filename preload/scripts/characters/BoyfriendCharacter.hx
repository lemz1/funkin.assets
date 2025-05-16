package characters;

import funkin.graphics.adobeanimate.FlxAtlasSprite;
import flixel.FlxG;
import funkin.audio.FunkinSound;
import funkin.play.character.MultiSparrowCharacter;
import funkin.play.GameOverSubState;
import funkin.play.PlayState;
import funkin.Preferences;
import funkin.Paths;

class BoyfriendCharacter extends MultiSparrowCharacter
{
  function new()
  {
    super('bf');
  }

  override function playAnimation(name:String, restart:Bool = false, ignoreOther:Bool = false, reverse:Bool = false)
  {
    if (name == "fakeoutDeath" && !this.debug)
    {
      doFakeoutDeath();
    }
    else
    {
      super.playAnimation(name, restart, ignoreOther, reverse);
    }
  }

  function doFakeoutDeath():Void
  {
    FunkinSound.playOnce(Paths.sound("gameplay/gameover/fakeout_death"), 1.0);

    var bfFakeout:FlxAtlasSprite = new FlxAtlasSprite(this.x - 440, this.y - 240, Paths.animateAtlas("characters/bfFakeOut", "shared"));
    FlxG.state.subState.add(bfFakeout);
    bfFakeout.zIndex = 1000;
    bfFakeout.playAnimation('');
    // We don't want people to miss this.
    var subState:GameOverSubState = cast FlxG.state.subState;
    @:privateAccess
    subState.mustNotExit = true;
    bfFakeout.onAnimationComplete.add((_) -> {
      bfFakeout.visible = false;
      this.visible = true;
      @:privateAccess
      subState.mustNotExit = false;
      this.playAnimation('firstDeath', true, true);
      // Play the "blue balled" sound. May play a variant if one has been assigned.
      GameOverSubState.playBlueBalledSFX();
    });
    bfFakeout.visible = true;
    this.visible = false;
  }

  override function getDeathQuote():Null<String>
  {
    switch (PlayState.instance.currentStage.getDad().characterId)
    {
      case "tankman":
        var randomCensor:Array<Int> = [];

        if (!Preferences.naughtyness) randomCensor = [1, 3, 8, 13, 17, 21];
        return Paths.sound('jeffGameover/jeffGameover-' + FlxG.random.int(1, 25, randomCensor));
      default:
        return null;
    }
  }
}
