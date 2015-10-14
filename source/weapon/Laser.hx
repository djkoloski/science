package weapon;

import flixel.util.FlxPoint;
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.FlxObject;
import flixel.system.FlxSound;

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
	public var width:Int;
	public var color:Int;
	public var cooldownPerShot:Float;
	public var soundEffect:FlxSound;
	
	public function new(state:PlayState, damageMask:Int, dps:Float, shotLength:Float, cooldownPerShot:Float, width:Int, color:Int)
	{
		super(state, damageMask);
		
		this.currentState = LaserState_Cooldown;
		this.dps = dps;
		this.timer = 0;
		this.shotLength = shotLength;
		this.cooldownPerShot = cooldownPerShot;
		this.width = width;
		this.color = color;
		this.soundEffect = FlxG.sound.load(AssetPaths.laser__wav);
		this.laserBeam = null;
	}
	
	public function transitionState(newState:LaserState):Void
	{
		currentState = newState;
		switch (newState)
		{
			case LaserState_Firing:
				timer = shotLength;
				soundEffect.play();
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
		laserBeam = new LaserBeam(state, damageMask, dps, width, color);
		add(laserBeam);
	}
	
	public function updateLaserBeam()
	{
		destroyLaserBeam();
		createLaserBeam();
		
		var start:FlxPoint = new FlxPoint(posX, posY);
		var dir:FlxPoint = new FlxPoint(dirX, dirY);
		var end:FlxPoint = new FlxPoint();
		
		state.level.foreground._raycast(start, dir, end);
		
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
	
	public override function getMaxCooldown():Float
	{
		return cooldownPerShot;
	}
	
	public override function getCooldown():Float
	{
		if (currentState == LaserState_Cooldown)
		{
			return timer;
		}
		else
		{
			return 0;
		}
	}
}