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
		
		this.weapon = new weapon.Laser(this.state, DamageMask.PLAYER, 60.0, 1.0, 1.0);
		this.sprite = new DamageableSprite();
		this.sprite.setProxy(this);
		this.sprite.loadGraphic(AssetPaths.player_walk__png, true, 32, 32);
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
	
	private function getMovementInput(output:FlxPoint):Bool
	{
		output.set(0, 0);
		if (FlxG.keys.pressed.D)
		{
			output.x = 1.0;
		}
		if (FlxG.keys.pressed.A)
		{
			output.x = -1.0;
		}
		if (FlxG.keys.pressed.S)
		{
			output.y = 1.0;
		}
		if (FlxG.keys.pressed.W)
		{
			output.y = -1.0;
		}
		
		if (output.x != 0 || output.y != 0)
		{
			var len = Math.sqrt(output.x * output.x + output.y * output.y);
			output.x /= len;
			output.y /= len;
			return true;
		}
		
		return false;
	}
	
	private function getWeaponInput(output:FlxPoint):Bool
	{
		output.set(0, 0);
		if (FlxG.keys.pressed.RIGHT)
		{
			output.x = 1.0;
		}
		if (FlxG.keys.pressed.LEFT)
		{
			output.x = -1.0;
		}
		if (FlxG.keys.pressed.DOWN)
		{
			output.y = 1.0;
		}
		if (FlxG.keys.pressed.UP)
		{
			output.y = -1.0;
		}
		
		if (output.x != 0 || output.y != 0)
		{
			var len = Math.sqrt(output.x * output.x + output.y * output.y);
			output.x /= len;
			output.y /= len;
			return true;
		}
		
		return false;
	}
	
	public function animatePlayer(dir:FlxPoint):Void
	{
		if (dir.x != 0 || dir.y != 0)
		{
			if (Math.abs(dir.x) >= Math.abs(dir.y))
			{
				if (dir.x > 0)
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
				if (dir.y > 0)
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
	
	public override function update():Void
	{
		super.update();
		
		var moveVector = new FlxPoint();
		var weaponVector = new FlxPoint();
		
		var moving = getMovementInput(moveVector);
		var firing = getWeaponInput(weaponVector);
		var weaponSwap: Bool = FlxG.keys.justPressed.Q;
		var meleeSwap:Bool = FlxG.keys.justPressed.SHIFT;
		
		var weaponX:Float = x + sprite.width / 2.0;
		var weaponY:Float = y + sprite.height / 2.0;
		
		if (weaponSwap)
		{
			// TODO: change weapons
		}
		
		if (meleeSwap)
		{
			// TODO: change to melee
		}
		
		var weaponRadius:Float = Math.sqrt(Math.pow(sprite.width / 2, 2) + Math.pow(sprite.height / 2, 2));
		weapon.setTransform(weaponX, weaponY, weaponVector.x, weaponVector.y, weaponRadius);
		
		if (firing)
		{
			animatePlayer(weaponVector);
			weapon.fire();
		}
		else
		{
			animatePlayer(moveVector);
		}
		
		velocity.x = moveVector.x * speed;
		velocity.y = moveVector.y * speed;
		
		stats.update();
	}
	
	public function getDamageableMask():Int
	{
		return DamageMask.PLAYER;
	}
	
	public function receiveDamage(amount:Int,source:Int):Void
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
