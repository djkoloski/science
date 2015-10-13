package weapon;

import flixel.util.FlxPoint;
import flixel.FlxG;

import flixel.FlxObject;

enum LaserState
{
	LaserState_Firing;
	LaserState_Cooldown;
}

class Laser extends Weapon
{
	public var currentState:LaserState;
	public var dps:Float;
	public var laserBeam:LaserBeam;
	public var timer:Float;
	public var shotLength:Float;
	public var cooldownPerShot:Float;
	
	public function new(state:PlayState, damageMask:Int, dps:Float, shotLength:Float, cooldownPerShot:Float)
	{
		super(state, damageMask);
		
		this.currentState = LaserState_Cooldown;
		this.dps = dps;
		this.timer = 0;
		this.shotLength = shotLength;
		this.cooldownPerShot = cooldownPerShot;
		this.laserBeam = null;
	}
	
	public function transitionState(newState:LaserState):Void
	{
		currentState = newState;
		switch (newState)
		{
			case LaserState_Firing:
				timer = shotLength;
			case LaserState_Cooldown:
				destroyLaserBeam();
				timer = cooldownPerShot;
			default:
				throw "Invalid state";
		}
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
	
	public function updateLaserBeam()
	{
		destroyLaserBeam();
		createLaserBeam();
		
		var start:FlxPoint = new FlxPoint(posX, posY);
		var tryEnd:FlxPoint = new FlxPoint(posX + dirX * 2000, posY + dirY * 2000);
		var end:FlxPoint = new FlxPoint();
		
		state.level.foreground.ray(start, tryEnd, end);
		
		laserBeam.setEndpoints(start.x, start.y, end.x, end.y);
	}
	
	public override function fire()
	{
		if (getCooldown() > 0)
		{
			return;
		}
		
		if (currentState != LaserState_Firing)
		{
			transitionState(LaserState_Firing);
		}
	}
	
	public override function update()
	{
		super.update();
		
		timer -= FlxG.elapsed;
		
		if (timer <= 0)
		{
			switch (currentState)
			{
				case LaserState_Firing:
					transitionState(LaserState_Cooldown);
				case LaserState_Cooldown:
				default:
					throw "Invalid state";
			}
		}
		else
		{
			switch (currentState)
			{
				case LaserState_Firing:
					updateLaserBeam();
				case LaserState_Cooldown:
				default:
					throw "Invalid state";
			}
		}
	}
	
	public override function getCooldown():Float
	{
		if (currentState == LaserState_Cooldown)
		{
			return timer / cooldownPerShot;
		}
		else
		{
			return 0;
		}
	}
}