package;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.util.FlxColor;
import flixel.util.FlxAngle;


class Player extends FlxSprite
{
	public var speed:Float;
	public var movementAngle:Float;
	
	public function new(startX:Float, startY:Float)
	{
		super(startX, startY);
		makeGraphic(32, 32, FlxColor.BLUE);
		
		speed = 200.0;
		angle = 0.0;
		
		drag.x = drag.y = 1600.0;
	}
	
	private function updateMovement():Void
	{
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
		
		if (dx != 0 || dy != 0)
		{
			movementAngle = Math.atan2(dy, dx) * 180 / Math.PI;
			
			var len = Math.sqrt(dx * dx + dy * dy);
			velocity.x = dx * speed / len;
			velocity.y = dy * speed / len;
		}
		else
		{
			velocity.x = 0;
			velocity.y = 0;
		}
	}
	
	public override function update():Void
	{
		super.update();
		updateMovement();
	}
}
