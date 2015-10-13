package;

import flixel.FlxSprite;
import flixel.util.FlxPoint;
import flixel.util.FlxColor;

using flixel.util.FlxSpriteUtil;

class AStarTest extends FlxSprite
{
	public function renderPath(start:FlxPoint, end:FlxPoint, path:Array<FlxPoint>, width:Int, height:Int):Void
	{
		makeGraphic(width, height, FlxColor.TRANSPARENT, true);
		
		var lineStyle:LineStyle = {
			thickness: 5,
			color: 0xFFFF0000
		};
		
		for (i in 0...path.length - 1)
		{
			drawLine(path[i].x, path[i].y, path[i + 1].x, path[i + 1].y, lineStyle);
		}
		
		updateSpriteGraphic();
	}
}