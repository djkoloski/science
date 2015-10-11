package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.util.FlxColor;
import flixel.util.FlxPoint;

import collision.DamageMask;
import collision.ICollidable;
import collision.IHittable;
import collision.DamageableSprite;
import collision.Collision;
import collision.CollisionFlags;

class Mob extends FlxGroup implements IHittable
{
	public var state:PlayState;
	
	public var stats:Stats;
	public var speed:Float;
	public var target:FlxPoint;
	public var maximumDistance:Float;
	public var minimumDistance:Float;
	public var weapon:Weapon;
	
	public var sprite:DamageableSprite;
	public var hud:MobHUD;
	
	public var x(get, set):Float;
	public var y(get, set):Float;
	public var width(get, set):Float;
	public var height(get, set):Float;
	public var velocity(get, never):FlxPoint;
	
	public function new(state:PlayState, startX:Float, startY:Float, damageMask:Int, spritePath:String = null)
	{
		super();
		
		this.state = state;
		
		this.stats = new Stats();
		this.speed = 50.0;
		this.target = new FlxPoint(startX, startY);
		this.maximumDistance = 1000.0;
		this.minimumDistance = 100.0;
		this.weapon = new Weapon(state, damageMask, WeaponType_Bullet2);
		
		this.sprite = new DamageableSprite(startX, startY);
		this.sprite.setProxy(this);
		if (spritePath == null)
		{
			this.sprite.makeGraphic(32, 32, FlxColor.GREEN);
		}
		else
		{
			this.sprite.loadGraphic(spritePath, true, 16, 16);
			this.sprite.animation.add("idle", [0]);
			this.sprite.animation.play("idle");
		}
		
		this.hud = new MobHUD(this);
		
		add(this.sprite);
		this.state.collision.add(this.sprite);
		add(this.hud);
	}
	
	public function updatePathing():Void
	{
		var dx = x - target.x;
		var dy = y - target.y;
		var dist = Math.sqrt(dx * dx + dy * dy);
		
		if (dist > maximumDistance)
		{
			// TODO: simple wander
			dx = 0;
			dy = 0;
		}
		else if (dist < minimumDistance)
		{
			if (dist != 0)
			{
				dx /= dist;
				dy /= dist;
			}
		}
		else
		{
			var path = state.level.foreground.findPath(new FlxPoint(x, y), target);
			if (path == null)
			{
				dx = 0;
				dy = 0;
			}
			else
			{
				dx = path[1].x - x;
				dy = path[1].y - y;
				dist = Math.sqrt(dx * dx + dy * dy);
				if (dist != 0)
				{
					dx /= dist;
					dy /= dist;
				}
			}
		}
		
		velocity.x = dx * speed;
		velocity.y = dy * speed;
	}
	
	public function attack():Void
	{
		var dx = target.x - x;
		var dy = target.y - y;
		var dist = Math.sqrt(dx * dx + dy * dy);
		if (dist != 0)
		{
			dx /= dist;
			dy /= dist;
		}
		var radius = Math.sqrt(width * width / 4 + height * height / 4) + 15.0;
		weapon.fire(x + width / 2 + dx * radius, y + height / 2 + dy * radius, Math.atan2(target.y - y, target.x - x));
	}
	
	public override function update()
	{
		super.update();
		
		updatePathing();
		
		stats.update();
		weapon.update();
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
			Collision.separate.bind(this.sprite, cast other),
			// Let damagers assign damage
			null,
			null
		);
	}
	
	public function getDamageableMask():Int
	{
		return DamageMask.PLAYER;
	}
	
	public function receiveDamage(amount:Int):Void
	{
		stats.damage(amount);
		if (stats.isDead())
		{
			destroy();
			state.add(new HeartCollectible(state, x, y));
		}
	}
	
	public function get_x():Float
	{
		return sprite.x;
	}
	
	public function set_x(value:Float):Float
	{
		return sprite.x = value;
	}
	
	public function get_y():Float
	{
		return sprite.y;
	}
	
	public function set_y(value:Float):Float
	{
		return sprite.y = value;
	}
	
	public function get_width():Float
	{
		return sprite.width;
	}
	
	public function set_width(value:Float):Float
	{
		return sprite.width = value;
	}
	
	public function get_height():Float
	{
		return sprite.height;
	}
	
	public function set_height(value:Float):Float
	{
		return sprite.height = value;
	}
	
	public function get_velocity():FlxPoint
	{
		return sprite.velocity;
	}
}