package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.FlxState;

class Player extends FlxSprite
{
	var state:FlxState;
	var speed:Float;
	
	public function new(state:FlxState, startX:Float, startY:Float) 
	{
		super();
		
		this.state = state;
		this.speed = 500.0;
		this.x = startX;
		this.y = startY;
		this.makeGraphic(32, 32, FlxColor.RED);
	}
	
	public override function update()
	{
		super.update();
		
		var dx:Float = 0;
		var dy:Float = 0;
		
		if (FlxG.keys.anyPressed(["RIGHT", "D"]))
		{
			dx += 1.0;
		}
		if (FlxG.keys.anyPressed(["LEFT", "A"]))
		{
			dx -= 1.0;
		}
		if (FlxG.keys.anyPressed(["DOWN", "S"]))
		{
			dy += 1.0;
		}
		if (FlxG.keys.anyPressed(["UP", "W"]))
		{
			dy -= 1.0;
		}
		
		var len = Math.sqrt(dx * dx + dy * dy);
		if (len > 0)
		{
			x += dx * FlxG.elapsed * speed / len;
			y += dy * FlxG.elapsed * speed / len;
		}
	}
}