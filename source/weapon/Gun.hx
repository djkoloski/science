package weapon;

import flixel.FlxG;
import flixel.system.FlxSound;

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
	public var damageAmount:Int;
	
	public var effect:String;
	public var soundEffect:FlxSound;
	
	public function new(
		state:PlayState,
		damageMask:Int,
		cooldownPerShot:Float,
		bulletRadius:Float,
		bulletLifespan:Float,
		bulletSpeed:Float,
		amount:Int,
		bulletColor:Int,
		effect:String="none"
		) 
	{
		super(state, damageMask);
		
		this.cooldownTimer = 0.0;
		this.cooldownPerShot = cooldownPerShot;
		this.bulletRadius = bulletRadius;
		this.bulletLifespan = bulletLifespan;
		this.bulletSpeed = bulletSpeed;
		this.bulletColor = bulletColor;
		this.damageAmount = amount;
		this.effect = effect;
		this.soundEffect = FlxG.sound.load(AssetPaths.gunshot__wav);
	}
	
	public override function fire()
	{
		if (cooldownTimer > 0)
		{
			return;
		}
		cooldownTimer = cooldownPerShot;
		
		state.add(
			new Bullet(
				state,
				posX,
				posY,
				dirX * bulletSpeed,
				dirY * bulletSpeed,
				damageMask,
				bulletRadius,
				bulletLifespan,
				damageAmount,
				bulletColor,
				effect
			)
		);
		
		soundEffect.play();
	}
	
	public override function update()
	{
		super.update();
		
		if (cooldownTimer > 0)
		{
			cooldownTimer -= FlxG.elapsed;
		}
	}
	
	public override function getMaxCooldown():Float
	{
		return cooldownPerShot;
	}
	
	public override function getCooldown():Float
	{
		return cooldownTimer;
	}
}