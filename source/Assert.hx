package;
import haxe.macro.Expr;
import haxe.macro.ExprTools;
import haxe.macro.Context;

class Assert
{
	public static macro function info(condition:Expr, ?message:Expr):Expr
	{
		#if debug
		var pos = Context.getPosInfos(Context.currentPos());
		var line = sys.io.File.getContent(pos.file).substr(0, pos.min).split("\n").length;
		var names = [];
		var values = [];
		var pickExpr = null;
		pickExpr = function(e:Expr):Void
		{
			switch (e.expr)
			{
				case EBinop(op, e1, e2):
					pickExpr(e1);
					pickExpr(e2);
				case EConst(CInt(_)):
				case EConst(CFloat(_)):
				case EConst(CString(_)):
				case EConst(CRegexp(_)):
				case _:
					names.push(ExprTools.toString(e));
					values.push(e);
			}
		};
		pickExpr(condition);
		return macro
		{
			if (!($e{condition}))
			{
				var names = $v{names};
				var values = $a{values};
				var message = "******** Assertion Failed ********\n";
				message += "Location:\t" + $v{pos.file} + ":" + $v{line} + "\n";
				message += "Expression:\t" + ($v{ExprTools.toString(condition)}) + "\n";
				if ($v{message != null})
					message += "Message:\t" + ($e{message}) + "\n";
				message += "Variables:\n";
				for (i in 0...names.length)
					message += "\t" + (i + 1) + ": " + names[i] + " = " + values[i] + "\n";
				message += "**********************************";
				throw message;
			}
		};
		#else
		return macro
		{};
		#end
	}
}