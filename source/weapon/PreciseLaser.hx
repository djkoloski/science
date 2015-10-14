package weapon;

import flixel.util.FlxPoint;
import flixel.FlxG;

import flixel.FlxObject;

class PreciseLaser extends Laser
{
	public function new(state:PlayState, damagemask:Int)
	{
		var dps: Float = 30;
		var shotLength: Float = 5;
		var cooldownPerShot : Float = 2;
		var width: Int = 4;
		var color: Int = 0xFF00FF00;
		
		super(state,damagemask, dps, shotLength, cooldownPerShot,width,color);
	}
}