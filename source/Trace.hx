package;

import haxe.macro.Expr;
import haxe.macro.Context;

class Trace
{
	public static macro function info(message:Expr):Expr 
	{
		var pos = Context.getPosInfos(Context.currentPos());
		var line = sys.io.File.getContent(pos.file).substr(0, pos.min).split("\n").length;
		
		if (Performance.ENABLED)
		{
			return macro
			{};
		}
		else
		{
			return macro
			{
				Sys.println($v{pos.file} + ":" + $v{line} + ": " + ($e{message}));
			};
		}
	}
}