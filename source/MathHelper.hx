package;

import flixel.util.FlxPoint;

class MathHelper
{
	public static function pointToLineSegmentDistance(v:FlxPoint, w:FlxPoint, p:FlxPoint):Float
	{
		var l2:Float = Math.pow(w.x - v.x, 2) + Math.pow(w.y - v.y, 2);
		if (l2 == 0.0)
		{
			return Math.sqrt(Math.pow(v.x - p.x, 2) + Math.pow(v.y - p.y, 2));
		}
		
		var t:Float = ((p.x - v.x) * (w.x - v.x) + (p.y - v.y) * (w.y - v.y)) / l2;
		
		if (t < 0)
		{
			return Math.sqrt(Math.pow(v.x - p.x, 2) + Math.pow(v.y - p.y, 2));
		}
		else if (t > 1.0)
		{
			return Math.sqrt(Math.pow(w.x - p.x, 2) + Math.pow(w.y - p.y, 2));
		}
		else
		{
			var proj:FlxPoint = new FlxPoint(v.x + t * (w.x - v.x), v.y + t * (w.y - v.y));
			return Math.sqrt(Math.pow(proj.x - p.x, 2) + Math.pow(proj.y - p.y, 2));
		}
	}
}