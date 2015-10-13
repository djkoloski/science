package;

class Performance
{
	#if debug
	public static inline var ENABLED = false;
	#else
	public static inline var ENABLED = true;
	#end
}