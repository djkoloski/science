package;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.util.FlxColor;
import flixel.util.FlxAngle;
import flixel.group.FlxGroup;
import flixel.util.FlxPoint;
import weapon.Weapon;

import collision.DamageableSprite;
import collision.DamageMask;
import collision.IHittable;
import collision.ICollidable;
import collision.Collision;
import collision.CollisionFlags;

class Player extends FlxGroup implements IHittable implements IPersistent
{
	public var state:PlayState;
	
	public var stats:Stats;
	public var speed:Float;
	
	public var weapon:weapon.Weapon;
	public var sprite:DamageableSprite;
	
	private var soundEffect:FlxSound;
	
	public var x(get, set):Float;
	public var y(get, set):Float;
	public var velocity(get, never):FlxPoint;
	
	public function new(state:PlayState)
	{
		super();
		
		this.state = state;
		
		this.stats = new Stats();
		this.speed = 500.0;
		
		this.weapon = new weapon.Laser(this.state, DamageMask.PLAYER, 60.0);
		this.sprite = new DamageableSprite();
		this.sprite.setProxy(this);
		this.sprite.loadGraphic("assets/images/player_walk.png", true, 32, 32);
		this.sprite.animation.add("up", [0, 1], 4, false);
		this.sprite.animation.add("down", [2,3], 4, false);
		this.sprite.animation.add("left", [4, 5], 4, false);
		this.sprite.animation.add("right", [6, 7], 4, false);
		this.sprite.drag.x = this.sprite.drag.y = 1600.0;
		
		soundEffect = FlxG.sound.load(AssetPaths.soundEffect__ogg);
		
		add(this.weapon);
		add(this.sprite);
	}
	
	public function onLevelLoad():Void
	{
		state.collision.add(this.sprite);
	}
	
	public function onLevelUnload():Void
	{}
	
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
		
		animatePlayer(dx, dy);
	}
	
	public function animatePlayer(dx:Float, dy:Float):Void
	{
		if (dx != 0 || dy != 0)
		{
			if (Math.abs(dx) >= Math.abs(dy))
			{
				if (dx > 0)
				{
					sprite.animation.play("right");
				}
				else
				{
					sprite.animation.play("left");
				}
			}
			else
			{
				if (dy > 0)
				{
					sprite.animation.play("down");
				}
				else
				{
					sprite.animation.play("up");
				}
			}
		}
	}
	
	public function updateWeapon():Void
	{
		var dx:Float = 0.0;
		var dy:Float = 0.0;
		
		if (FlxG.keys.pressed.RIGHT)
		{
			dx += 1.0;
			soundEffect.play();
		}
		if (FlxG.keys.pressed.LEFT)
		{
			dx -= 1.0;
			soundEffect.play();
		}
		if (FlxG.keys.pressed.DOWN)
		{
			dy += 1.0;
			soundEffect.play();
		}
		if (FlxG.keys.pressed.UP)
		{
			dy -= 1.0;
			soundEffect.play();
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
			// TODO: change weapons
		}
		
		if (meleeSwap)
		{
			// TODO: change to melee
		}
		
		if (dx != 0 || dy != 0)
		{
			weapon.fire(
				weaponX,
				weaponY,
				fireAngle
			);
			
			animatePlayer(dx, dy);
		}
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
		return DamageMask.PLAYER;
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
