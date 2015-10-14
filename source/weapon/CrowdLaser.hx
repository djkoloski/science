package weapon;

import flixel.util.FlxPoint;
import flixel.FlxG;

import flixel.FlxObject;

class CrowdLaser extends Laser
{
	public function new(state:PlayState,damagemask:Int)
	{
		var dps: Float = 10;
		var shotLength: Float = 3;
		var cooldownPerShot : Float = 2;
		var width: Int = 64;
		var color: Int = 0x0F0000FF;
		
		super(state, damagemask, dps, shotLength, cooldownPerShot,width,color);
	}
}