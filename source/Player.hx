
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
	public var speed :Float = 200; 
	public var Angle :Float = 0;

	
	public function new(X:Float, Y:Float)
	{
		super(X, Y);
		makeGraphic(16, 16, FlxColor.BLUE);
		
		drag.x = drag.y = 1600;
		
	}
	private function movement():Void
	{
		var up:Bool = false;
		var right:Bool = false;
		var left:Bool = false;
		var down:Bool = false;
		
		up = FlxG.keys.anyPressed(["UP", "W"]);
		right = FlxG.keys.anyPressed(["RIGHT", "D"]);
		left = FlxG.keys.anyPressed(["LEFT", "A"]);
		down = FlxG.keys.anyPressed(["DOWN", "S"]);
		
		 if (up && down)
			up = down = false;
			
		if (left && right)
			left = right = false;
		
		if (up || down || left || right) 
		{
		
			velocity.x = speed;
			velocity.y = speed; 
			var angle:Float = 0;
			
			if (up) 
			{
				angle = -90;
				if (left)
				{
					angle -= 45;
				}
				else if (right)
				{
					angle += 45;
				}
				
			}
			else if (down)
			{
				angle = 90;
				if (left)
				{
					angle += 45;
				}
				else if (right)
				{
					angle -= 45;
				}
			}
			else if (left)
			{
				angle = 180;
			}
			else if (right)
			{
				angle = 0;
			}
			
			Angle = angle;
			FlxAngle.rotatePoint(speed, 0, 0, 0, angle, velocity);
		}
		
		
	}
	public override function update():Void
	{
		movement();
		super.update();
	
	}
	

	}