package;

import flixel.FlxSprite;
import flixel.FlxG;
import haxe.Constraints.FlatEnum;

/**
 * ...
 * @author ...
 */
class Shockwave extends FlxSprite
{

	var timer:Float;
	var maxtime:Float = .5;
	public function new(x:Float,y:Float) 
	{
		super();
		loadGraphic(AssetPaths.groundhit__png, true, 64, 64);
		animation.add("play", [0, 1, 2, 3, 4], 5, true );
		timer = maxtime;
		this.x = x;
		this.y = y;
	}
	
	
	public override function update() {
		timer -= FlxG.elapsed;
		if (timer < 0) {
			destroy();
		}
	}
}