package;

#if !macro
@:build(__Boot__.build())
class __Boot__ {}
#else
import haxe.macro.Context;
import haxe.macro.Type;
import haxe.macro.Expr;

using haxe.macro.Tools;
using StringTools;

class __Boot__
{
  public static function onGenerate(types:Array<Type>):Void
  {
    var classList:Array<Expr> = [];

    for (type in types)
    {
      switch (type)
      {
        case TInst(t, _):
          if (haxe.io.Path.normalize(t.get().pos.getInfos().file).contains('haxe/std') || t.get().name == '__Boot__') continue;

          classList.push(macro $v{t.toString()});

        default:
      }
    }

    switch (Context.getType('__Boot__'))
    {
      case TInst(_.get() => t, _):
        t.meta.add('classList', classList, Context.currentPos());
      default:
        throw '???';
    }
  }

  public static function build():Array<Field>
  {
    Context.onGenerate(onGenerate);
    return Context.getBuildFields();
  }
}
#end
