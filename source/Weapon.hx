
package;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.util.FlxColor;
import flixel.util.FlxAngle;
import flixel.FlxBasic;

class Weapon extends FlxSprite
{
	public var speed :Float = 300; 
	public var Angle :Float = 0;
	public var Death :Float = 0;
	public var choice: Float = 0;
	public function new(X:Float, Y:Float, angle:Float, choice:Float)
	{
		Angle = angle;
		super(X+12, Y+12);
		if (choice== 0)
		{
			makeGraphic(16, 16, FlxColor.RED);
			Death = 3;
			speed = 600;
		}
		
		if (choice == 1)
		{
			makeGraphic(8, 8, FlxColor.RED);
			Death = 60;
		}
		if (choice == 2)
		{
			makeGraphic(8, 8, FlxColor.GREEN);
			Death = 60;
		}
		if (choice == 3)
		{
			makeGraphic(8, 8, FlxColor.YELLOW);
			Death = 60;
		}
	}
	private function fired()
	{
			velocity.x = speed;
			velocity.y = speed; 
			FlxAngle.rotatePoint(speed, 0, 0, 0, Angle, velocity);
	}
	
	public override function update():Void
	{
		fired();
		Death--;
		if (Death <= 0)
		{
			this.kill();
		}
		super.update();
	
	}
}