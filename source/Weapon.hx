package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.util.FlxColor;
import flixel.FlxState;

enum WeaponType
{
	WeaponType_Melee;
	WeaponType_Bullet1;
	WeaponType_Bullet2;
	WeaponType_Bullet3;
}

class Weapon
{
	private var state:PlayState;
	
	public var damageMask:Int;
	public var cooldownTimer:Float;
	
	public var type:WeaponType;
	public var bulletCooldown:Float;
	public var bulletRadius:Float;
	public var bulletLifespan:Float;
	public var bulletSpeed:Float;
	public var bulletColor:Int;
	
	public function new(state:PlayState, damageMask:Int, ?newType:WeaponType)
	{
		if (newType == null)
		{
			newType = WeaponType_Melee;
		}
		
		this.state = state;
		this.damageMask = damageMask;
		this.cooldownTimer = 0;
		
		setType(newType);
	}
	
	public function setType(newType:WeaponType)
	{
		type = newType;
		switch (type)
		{
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

			default:
				throw "Unknown weapon type";
		}
		cooldownTimer = bulletCooldown;
	}
	
	public function fire(bulletX:Float, bulletY:Float, bulletAngle:Float)
	{
		if (cooldownTimer > 0)
		{
			return;
		}
		cooldownTimer = bulletCooldown;
		
		state.add(
			new Bullet(
				state,
				bulletX,
				bulletY,
				bulletAngle,
				damageMask,
				bulletRadius,
				bulletLifespan,
				bulletSpeed,
				bulletColor
			)
		);
	}
	
	public function fireType(bulletX:Float, bulletY:Float, bulletAngle:Float, bulletType:WeaponType)
	{
		var currentType = type;
		setType(bulletType);
		fire(bulletX, bulletY, bulletAngle);
		setType(currentType);
	}
	
	public function update()
	{
		if (cooldownTimer > 0)
		{
			cooldownTimer -= FlxG.elapsed;
		}
	}
	
	public function getCooldown()
	{
		return cooldownTimer / bulletCooldown;
	}
}