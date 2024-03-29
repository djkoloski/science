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
import weapon.CrowdLaser;
import weapon.Laser;
import weapon.MachineGun;
import weapon.PreciseLaser;
import weapon.RocketLauncher;
import weapon.Shotgun;
import weapon.Sniper;
import weapon.StartingGun;
import weapon.Weapon;

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
	
	public var weapon:weapon.Weapon;
	public var sprite:DamageableSprite;
	
	private var soundEffect:FlxSound;
	
	public var x(get, set):Float;
	public var y(get, set):Float;
	public var velocity(get, null):FlxPoint;
	
	public var invincible:Bool;
	
	public var stunned:Bool = false;
	public var stunTimer:Float = 0;
	public var maxStun:Float = 1;
	public var stunVelocity:FlxPoint;
	
	public function stun(vel:FlxPoint):Void {
		stunVelocity = vel;
		stunned = true; 
		stunTimer = maxStun;
	}
	
	public var shotgun: Shotgun;
	public var sniper: Sniper;
	public var rocketLauncher: RocketLauncher;
	public var laser: Laser;
	public var startingGun: StartingGun;
	public var machineGun: MachineGun;
	public var crowdLaser: CrowdLaser;
	public var preciseLaser: PreciseLaser;
	
	public function new(state:PlayState)
	{
		super();
		
		this.state = state;
		
		this.stats = new Stats();
		this.speed = 500.0;
		
		shotgun = new Shotgun(this.state);
		sniper = new Sniper(this.state);
		rocketLauncher = new RocketLauncher(this.state);
		laser = new Laser(this.state, DamageMask.PLAYER, 20.0, 1.0, 1.0, 3, FlxColor.RED);
		preciseLaser = new PreciseLaser(this.state, DamageMask.PLAYER);
		crowdLaser = new CrowdLaser(this.state, DamageMask.PLAYER);
		laser = new Laser(this.state, DamageMask.PLAYER, 60.0, 1.0, 1.0, 3, FlxColor.RED);
		startingGun = new StartingGun(this.state);
		machineGun = new MachineGun(this.state);
		
		invincible = false;
		
		this.weapon = startingGun;
		this.sprite = new DamageableSprite();
		this.sprite.setProxy(this);
		this.sprite.loadGraphic(AssetPaths.player_walk__png, true, 32, 32);
		this.sprite.animation.add("up", [0, 1], 4, false);
		this.sprite.animation.add("down", [2,3], 4, false);
		this.sprite.animation.add("left", [4, 5], 4, false);
		this.sprite.animation.add("right", [6, 7], 4, false);
		this.sprite.drag.x = this.sprite.drag.y = 1600.0;
		
		soundEffect = FlxG.sound.load(AssetPaths.soundEffect__ogg);
		
		state.enemies.push(this);
		
		//add(this.weapon);
		add(this.shotgun);
		add(this.sniper);
		add(this.rocketLauncher);
		add(this.laser);
		add(this.preciseLaser);
		add(this.crowdLaser);
		add(this.startingGun);
		add(this.machineGun);
		add(this.sprite);
		
		this.state.collision.add(this.sprite);
	}
	
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
	
	private function switchWeapons():Void 
	{
		if (FlxG.keys.pressed.ONE && !rocketLauncher.locked)
		{
			weapon = rocketLauncher;
		}
		
		if (FlxG.keys.pressed.TWO && !sniper.locked)
		{
			weapon = sniper;
		}
		
		if (FlxG.keys.pressed.THREE && !shotgun.locked)
		{
			weapon = shotgun;
		}
		
		if (FlxG.keys.pressed.FOUR && !laser.locked)
		{
			weapon = laser;
		}
		
		if (FlxG.keys.pressed.FIVE && !machineGun.locked)
		{
			weapon = machineGun;
		}
		
		if (FlxG.keys.pressed.SIX)
		{
			weapon = startingGun;
		}
		
		if (FlxG.keys.pressed.SEVEN && !crowdLaser.locked)
		{
			weapon = crowdLaser;
		}
		
		if (FlxG.keys.pressed.EIGHT && !preciseLaser.locked)
		{
			weapon = preciseLaser;
		}
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
		
		var weaponX:Float = x + sprite.width / 2.0;
		var weaponY:Float = y + sprite.height / 2.0;
		
		switchWeapons();
		
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
		
		if (stunned) {
			//trace(stunVelocity);
			velocity.x = stunVelocity.x;
			velocity.y = stunVelocity.y;
			stunTimer -= FlxG.elapsed;
			if (stunTimer <= 0) {
				stunned = false;
			}
		}else{
		
			velocity.x = moveVector.x * speed;
			velocity.y = moveVector.y * speed;
		}
		stats.update();
		
		if (FlxG.keys.justPressed.I)
		{
			invincible = true;
		}
	}
	
	public function getDamageableMask():Int
	{
		return DamageMask.PLAYER;
	}
	
	public function reset():Void
	{
		this.stats.hearts = 3;
		this.stats.residualMax = 30;
		this.stats.residualCurrent = 0;
		this.stats.regen = 1;
	}
	
	public function receiveDamage(amount:Int,source:Int):Void
	{
		if (invincible)
		{
			return;
		}
		
		stats.damage(amount);
		if (stats.isDead())
		{
			reset();
			this.state.changeLevel(this.state.currentLevel);
		}
	}
	
	public function getCollisionFlags():Int
	{
		return CollisionFlags.NONE;
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
