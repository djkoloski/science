package;

import haxe.macro.Expr;

class Trace
{
	public static macro function info(message:Expr):Expr 
	{
		if (Performance.ENABLED)
		{
			return macro
			{};
		}
		else
		{
			return macro
			{
				trace($e{message});
			};
		}
	}
}