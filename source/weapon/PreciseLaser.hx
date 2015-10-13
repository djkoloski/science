package weapon;

import flixel.util.FlxPoint;
import flixel.FlxG;

import flixel.FlxObject;

class PreciseLaser extends Laser
{
	public function new(state:PlayState)
	{
		var damagemask:Float = Player;
		var dps: Float = 20;
		var shotLength: Float = 5;
		var cooldownPerShot : Float = 2;
		
		super(state, damagemask, dps, shotLength, cooldownPerShot);
	}
}