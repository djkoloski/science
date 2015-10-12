package weapon;

import flixel.FlxG;

/*
case WeaponType_Melee:
	bulletCooldown = 0.1;
	bulletRadius = 8;
	bulletLifespan = 0.05;
	bulletSpeed = 600;
	bulletColor = FlxColor.RED;
	
case WeaponType_Bullet1:
	bulletCooldown = 0.2;
	bulletRadius = 4;
	bulletLifespan = .5;
	bulletSpeed = 600;
	bulletColor = FlxColor.RED;
	
case WeaponType_Bullet2:
	bulletCooldown = 0.2;
	bulletRadius = 4;
	bulletLifespan = 1.0;
	bulletSpeed = 600;
	bulletColor = FlxColor.GREEN;
	
case WeaponType_Bullet3:
	bulletCooldown = 0.6;
	bulletRadius = 2;
	bulletLifespan = 3.0;
	bulletSpeed = 1000;
	bulletColor = FlxColor.YELLOW;
*/

class Gun extends Weapon
{
	public var cooldownTimer:Float;
	public var cooldownPerShot:Float;
	public var bulletRadius:Float;
	public var bulletLifespan:Float;
	public var bulletSpeed:Float;
	public var bulletColor:Int;
	
	public function new(
		state:PlayState,
		damageMask:Int,
		cooldownPerShot:Float,
		bulletRadius:Float,
		bulletLifespan:Float,
		bulletSpeed:Float,
		bulletColor:Int
		) 
	{
		super(state, damageMask);
		
		this.cooldownTimer = 0.0;
		this.cooldownPerShot = cooldownPerShot;
		this.bulletRadius = bulletRadius;
		this.bulletLifespan = bulletLifespan;
		this.bulletSpeed = bulletSpeed;
		this.bulletColor = bulletColor;
	}
	
	public override function fire(startX:Float, startY:Float, angle:Float)
	{
		if (cooldownTimer > 0)
		{
			return;
		}
		cooldownTimer = cooldownPerShot;
		
		state.add(
			new Bullet(
				state,
				startX,
				startY,
				angle,
				damageMask,
				bulletRadius,
				bulletLifespan,
				bulletSpeed,
				bulletColor
			)
		);
	}
	
	public override function update()
	{
		super.update();
		
		if (cooldownTimer > 0)
		{
			cooldownTimer -= FlxG.elapsed;
		}
	}
}