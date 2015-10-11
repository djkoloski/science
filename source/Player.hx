package;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.util.FlxColor;
import flixel.util.FlxAngle;
import flixel.group.FlxGroup;
import flixel.util.FlxPoint;

import collision.DamageableSprite;
import collision.DamageMask;
import collision.IHittable;
import collision.ICollidable;
import collision.Collision;
import collision.CollisionFlags;

class Player extends FlxGroup implements IHittable
{
	public var state:PlayState;
	
	public var stats:Stats;
	public var speed:Float;
	public var weapon:Weapon;
	
	public var sprite:DamageableSprite;
	
	public var x(get, set):Float;
	public var y(get, set):Float;
	public var velocity(get, never):FlxPoint;
	
	public function new(state:PlayState)
	{
		super();
		
		this.state = state;
		
		this.stats = new Stats();
		this.speed = 500.0;
		this.weapon = new Weapon(this.state, DamageMask.PLAYER, WeaponType_Bullet1);
		
		this.sprite = new DamageableSprite();
		this.sprite.setProxy(this);
		this.sprite.loadGraphic("assets/images/player.png", true, 32, 32);
		this.sprite.animation.add("up", [0, 1], 4, false);
		this.sprite.animation.add("down", [2,3], 4, false);
		this.sprite.animation.add("right", [4, 5], 4,false);
		this.sprite.animation.add("left", [6, 7], 4, false);
		
		add(this.sprite);
		setup();
	}
	
	public function setup():Void
	{
		this.state.collision.add(this.sprite);
	}
	
	private function updateMovement():Void
	{
		var dx:Float = 0;
		var dy:Float = 0;
		
		if (FlxG.keys.pressed.D)
		{
			dx += 1.0;
		}
		if (FlxG.keys.pressed.A)
		{
			dx -= 1.0;
		}
		if (FlxG.keys.pressed.S)
		{
			dy += 1.0;
		}
		if (FlxG.keys.pressed.W)
		{
			dy -= 1.0;
		}
		
		if (dx != 0 || dy != 0)
		{
			var len = Math.sqrt(dx * dx + dy * dy);
			velocity.x = dx * speed / len;
			velocity.y = dy * speed / len;
		}
		else
		{
			velocity.x = 0;
			velocity.y = 0;
		}
		
		animationPlayer(dx, dy);
	}
	
	public function animationPlayer(dx:Float, dy:Float):Void
	{
		if (dy == 1.0)
		{
			sprite.animation.play("up");
		} 
		else if (dy == -1.0)
		{
			sprite.animation.play("down");
		}
		else if (dx == 1.0)
		{
			sprite.animation.play("right");
		}
		else if (dx == -1.0)
		{
			sprite.animation.play("left");
		}
	}
	
	public function updateWeapon():Void
	{
		var dx:Float = 0.0;
		var dy:Float = 0.0;
		
		if (FlxG.keys.pressed.RIGHT)
		{
			dx += 1.0;
		}
		if (FlxG.keys.pressed.LEFT)
		{
			dx -= 1.0;
		}
		if (FlxG.keys.pressed.DOWN)
		{
			dy += 1.0;
		}
		if (FlxG.keys.pressed.UP)
		{
			dy -= 1.0;
		}
		
		var len:Float = Math.sqrt(dx * dx + dy * dy);
		if (len != 0)
		{
			dx /= len;
			dy /= len;
		}
		var fireAngle:Float = Math.atan2(dy, dx);
		
		var weaponSwap: Bool = FlxG.keys.justPressed.Q;
		var meleeSwap:Bool = FlxG.keys.justPressed.SHIFT;
		
		// TODO: Increase this so that bullets stop hitting the player immediately and dying
		var weaponX:Float = x + sprite.width / 2.0 + dx * sprite.width;
		var weaponY:Float = y + sprite.height / 2.0 + dy * sprite.height;
		
		if (weaponSwap)
		{
			switch (weapon.type)
			{
				case WeaponType_Bullet1:
					weapon.setType(WeaponType_Bullet2);
				case WeaponType_Bullet2:
					weapon.setType(WeaponType_Bullet3);
				case WeaponType_Bullet3:
					weapon.setType(WeaponType_Bullet1);
				case WeaponType_Melee:
					weapon.setType(WeaponType_Bullet1);
				default:
					throw "Unknown weapon type";
			}
		}
		
		if (meleeSwap)
		{
			if (weapon.type == WeaponType_Melee)
			{
				weapon.setType(WeaponType_Bullet1);
			}
			else
			{
				weapon.setType(WeaponType_Melee);
			}
		}
		
		if (dx != 0 || dy != 0)
		{
			weapon.fire(
				weaponX,
				weaponY,
				fireAngle
			);
		}
		
		weapon.update();
	}
	
	public override function update():Void
	{
		super.update();
		updateMovement();
		updateWeapon();
		
		stats.update();
	}
	
	public function getDamageableMask():Int
	{
		return DamageMask.ENEMY;
	}
	
	public function receiveDamage(amount:Int):Void
	{
		stats.damage(amount);
	}
	
	public function getCollisionFlags():Int
	{
		return CollisionFlags.SOLID;
	}
	
	public function onCollision(other:ICollidable):Void
	{
		Collision.switchFlags(
			this,
			other,
			Collision.separate.bind(sprite, cast other),
			// Let damagers assign damage
			null,
			null
		);
	}
	
	public function get_x():Float
	{
		return this.sprite.x;
	}
	
	public function set_x(value:Float):Float
	{
		return this.sprite.x = value;
	}
	
	public function get_y():Float
	{
		return this.sprite.y;
	}
	
	public function set_y(value:Float):Float
	{
		return this.sprite.y = value;
	}
	
	public function get_velocity():FlxPoint
	{
		return this.sprite.velocity;
	}
}
