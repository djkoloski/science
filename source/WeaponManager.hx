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

class WeaponManager
{
	private var state:PlayState;
	
	public var bullets:FlxGroup;
	public var type:WeaponType;
	public var side:Int;
	
	public var cooldownTimer:Float;
	
	public var bulletCooldown:Float;
	public var bulletRadius:Float;
	public var bulletLifespan:Float;
	public var bulletSpeed:Float;
	public var bulletColor:Int;
	
	public function new(playState:PlayState, side:Int, ?newType:WeaponType)
	{
		if (newType == null)
		{
			newType = WeaponType_Melee;
		}
		
		state = playState;
		this.side = side;
		
		bullets = new FlxGroup();
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
				bulletLifespan = 1.0;
				bulletSpeed = 600;
				bulletColor = FlxColor.RED;
			case WeaponType_Bullet2:
				bulletCooldown = 0.2;
				bulletRadius = 4;
				bulletLifespan = 1.0;
				bulletSpeed = 600;
				bulletColor = FlxColor.GREEN;
			case WeaponType_Bullet3:
				bulletCooldown = 0.2;
				bulletRadius = 4;
				bulletLifespan = 1.0;
				bulletSpeed = 600;
				bulletColor = FlxColor.YELLOW;
			default:
				throw "Unknown weapon type";
		}
	}
	
	public function fire(bulletX:Float, bulletY:Float, bulletAngle:Float)
	{
		if (cooldownTimer > 0)
		{
			return;
		}
		cooldownTimer = bulletCooldown;
		
		state.addBullet(
			new Bullet(
				bulletX,
				bulletY,
				bulletAngle,
				side,
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
}