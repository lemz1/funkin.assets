package dialogue.boxes;

import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import funkin.play.cutscene.dialogue.Conversation;
import funkin.play.cutscene.dialogue.DialogueBox;
import funkin.modding.events.ScriptEvent;

class ThornsDialogueBox extends DialogueBox
{
  public function new()
  {
    super('thorns');
  }

  // CPPIA: Duplicated function???
  // override public function onDialogueLine(event:DialogueScriptEvent):Void
  // {
  //   super.onDialogueLine(event);
  //   if (getCurrentAnimation() == 'idle')
  //   {
  //     // click, then speaking
  //     playAnimation('click');
  //   }
  //   else if (getCurrentAnimation() == 'click')
  //   {
  //     playAnimation('speaking');
  //   }
  // }

  override function onAnimationFinished(name:String):Void
  {
    super.onAnimationFinished(name);

    if (name == 'sentenceEnd')
    {
      playAnimation('idle');
    }
    if (name == 'click')
    {
      playAnimation('speaking');
    }
  }

  override function onTypingComplete():Void
  {
    playAnimation('sentenceEnd');
    super.onTypingComplete();
  }

  override public function onDialogueStart(event:DialogueScriptEvent):Void
  {
    super.onDialogueStart(event);
  }

  override public function onDialogueLine(event:DialogueScriptEvent):Void
  {
    // Override the default box animation behavior by switching the state
    @:privateAccess
    event.conversation.state = ConversationState.Opening;

    playAnimation('click', false);
    super.onDialogueLine(event);
  }

  public override function onDialogueEnd(event:DialogueScriptEvent):Void
  {
    super.onDialogueEnd(event);
    // Play 'enter' in reverse
    this.textDisplay.visible = false;

    playAnimation('exit', false);
  }

  override function onDestroy(event:ScriptEvent)
  {
    super.onDestroy(event);
  }
}
