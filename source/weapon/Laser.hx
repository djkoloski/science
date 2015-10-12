package weapon;

import flixel.util.FlxPoint;

class Laser extends Weapon
{
	public static inline var FRAME_LIMIT:Int = 5;
	
	public var dps:Float;
	public var laserBeam:LaserBeam;
	public var framesSinceFire:Int;
	
	public function new(state:PlayState, damageMask:Int, dps:Float)
	{
		super(state, damageMask);
		
		this.dps = dps;
		this.laserBeam = null;
		this.framesSinceFire = 0;
	}
	
	public function destroyLaserBeam()
	{
		if (laserBeam != null)
		{
			remove(laserBeam);
			laserBeam.destroy();
			laserBeam = null;
		}
	}
	
	public function createLaserBeam()
	{
		laserBeam = new LaserBeam(state, damageMask, dps);
		add(laserBeam);
	}
	
	public override function fire(startX:Float, startY:Float, angle:Float)
	{
		framesSinceFire = 0;
		
		destroyLaserBeam();
		createLaserBeam();
		
		var start:FlxPoint = new FlxPoint(startX, startY);
		var direction:FlxPoint = new FlxPoint(Math.cos(angle), Math.sin(angle));
		var end:FlxPoint = new FlxPoint();
		
		state.level.foreground.raycast(start, direction, end);
		
		laserBeam.setEndpoints(start.x, start.y, end.x, end.y);
	}
	
	public override function update()
	{
		super.update();
		
		if (framesSinceFire < FRAME_LIMIT)
		{
			++framesSinceFire;
		}
		
		if (laserBeam != null && framesSinceFire == FRAME_LIMIT)
		{
			destroyLaserBeam();
			framesSinceFire = FRAME_LIMIT + 1;
		}
	}
}