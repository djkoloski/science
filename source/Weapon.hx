
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
	public var speed :Float = 200; 
	public var Angle :Float = 0;
	public var Death :Float = 60;
	public function new(X:Float, Y:Float, angle:Float, WoB:Float)
	{
		Angle = angle;
		super(X, Y);
		if (WoB == 1)
		{
			makeGraphic(16, 16, FlxColor.RED);
		}
		
		if (WoB == 2)
		{
			makeGraphic(8, 8, FlxColor.RED);
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