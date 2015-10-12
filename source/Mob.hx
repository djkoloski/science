package;

import collision.IDamageable;
import flixel.FlxG;
import flixel.FlxObject;
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
	public var playstate:PlayState;
	
	public var stats:Stats;
	public var speed:Float;
	public var target:Dynamic;
	public var maximumDistance:Float;
	public var minimumDistance:Float;
	public var weapon:Weapon;
	public var action:Dynamic;
	
	public var destination: FlxPoint;
	
	
	public var sightRadius:Int;
	public var sightCollider:OverlapSquare;
	
	public var sprite:DamageableSprite;
	public var hud:MobHUD;
	
	public var x(get, set):Float;
	public var y(get, set):Float;
	public var width(get, set):Float;
	public var height(get, set):Float;
	public var velocity(get, set):FlxPoint;
	
	public var maxHearts:Int;
	public var followDistance:Int;
	
	public var idleAction = function() { };
	
	//public var hud:MobHUD;
	//public var stats:Stats;
	
	
	public function new(playstate:PlayState, startX:Float, startY:Float, damageMask:Int, spritePath:String = null)
	{
		super();
		sightRadius = 1000;
		followDistance = 100;

		this.playstate = playstate;
		if (maxHearts == null) {
			this.stats = new Stats();
		}else {
			this.stats = new Stats(maxHearts);
		}
		this.speed = 50.0;
		//this.target = new FlxPoint(startX, startY);
		this.maximumDistance = 1000.0;
		this.minimumDistance = 100.0;
		this.weapon = new Weapon(playstate, damageMask, WeaponType_Bullet2);
		
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
		sightCollider = new OverlapSquare(x - (sightRadius / 2), y - (sightRadius / 2), sightRadius, sightRadius);
		add(sightCollider);
		this.playstate.collision.add(sightCollider);
		
		add(this.sprite);
		this.playstate.collision.add(this.sprite);
		add(this.hud);
		//sprite.immovable = true;
	}
	
	
	public function goTo(point:FlxPoint): Bool {
		//Moves towards target point, returning true if it has arrived. 
		Assert.info(point.x > 0 && point.y > 0, "Something is moving to a point offscreen.");
		//trace("going to");
		moveTowards(point);
		if (distanceTo(point) < speed * FlxG.elapsed) {
			return true;
		}
		return false;
	}
	
	
	public var path:Array<FlxPoint>;
	public function pathTo(point:FlxPoint): Bool {
		//Paths towards the given point, returning true if it has arrived, false otherwise. CALLED EVERY FRAME.
		
		if (path == null ||  path[path.length - 1].x != point.x || path[path.length - 1].y != point.y) {
			//trace("path is not valid");
			//var other =  new FlxPoint(point.x, point.y);
			//trace("going from: " + x + "," + y + " to: " + point.x + "," + point.y);
			if (!playstate.level.foreground.getBounds().containsFlxPoint(point)) {
				trace("path outside of level");
				return true;
			}
			path = playstate.level.foreground.findPath(new FlxPoint(x, y), point);
			
			/*for (point in path) {
				trace(point.toString());
			}*/
			//trace("reaches here");
			//path = playstate.level.foreground.findPath(new FlxPoint(128, 128), new FlxPoint(256, 128));
			if (path == null) {
				//trace("there is no path.");
			}
			if (path == null || path.length == 0) {
				//trace("path length 0");
				path = null;
				return true;
			}
		}
		//trace("reaches 2");
		if (path.length == 0) {
			trace("path length 0");
			path = null;
			return true;
		}
		if (goTo(path[0])) {
			
			path.reverse();
			path.pop();
			path.reverse();
			if (path.length == 0) {
				path = null;
				return true;
			}
		}
		return false;
	}
	
	public function fire() {
		//fires at the target
		Assert.info(target != null);
		//trace("firing");
		var velocities:FlxPoint = towardsSprite(target);
		var angle:Float = Math.atan2(velocities.y, velocities.x);
		//trace(angle);
		weapon.fire(x, y, angle);
	}
	
	public function getTarget() {
		for (obj in sightCollider.getCollisionList()) {
			if (obj.getDamageableMask() != this.getDamageableMask()) {
				target = obj;
				return true;
			}
		}
		return false;	
	}
	

	public function stopShort(point:FlxPoint):FlxPoint {
		//returns a point that is followdistance away from point. If closer than followdistance, it will return the current position.
		var temp :FlxPoint = towards(point);
		var dist :Float = distanceTo(point);
		return new FlxPoint(x + temp.x * (dist - followDistance), y + temp.y * (dist - followDistance));
	}

	public function distanceTo(point:FlxPoint):Float {
		return Math.max(Math.sqrt(  (x - point.x)  * (x - point.x)  + (y - point.y) * (y - point.y)),0);
	}

	public function towardsSprite(sprite:Dynamic):FlxPoint {
		//towards for a sprite..
		return towards(new FlxPoint(sprite.get_x(), sprite.get_y()));
	}

	public function towards(point:FlxPoint):FlxPoint {
		//returns a normalized FlxPoint in the direction of point.
		Assert.info(!Math.isNaN(point.x) && !Math.isNaN(point.y));
		var tempx = point.x - x;
		var tempy = point.y - y;
		var len:Float = Math.sqrt( tempx * tempx + tempy * tempy);
		
		if (len == 0) {
			return new FlxPoint(0, 0);
		}
		//trace("direction: " + (tempx / len) + "," + (tempy / len));
		return new FlxPoint(tempx / len, tempy / len);
	}
	
	public function moveTowards(point:FlxPoint):Void {
		Assert.info(!Math.isNaN(point.x) && !Math.isNaN(point.y));
		Assert.info(!Math.isNaN(x) && !Math.isNaN(y));
		
		var dir = towards(point);
		this.velocity = new FlxPoint(dir.x * speed /* FlxG.elapsed*/, dir.y * speed /* FlxG.elapsed*/);
		//x += dir.x * speed * FlxG.elapsed;
		//y += dir.y * speed * FlxG.elapsed;
		Assert.info(!Math.isNaN(this.velocity.x) && !Math.isNaN(this.velocity.y));
		//trace("moving towards " + point.x + "," + point.y);
	}
	
	public override function draw():Void {
		super.draw();
		
		hud.draw();
	}
	
	

	public override function update()
	{
		Assert.info(action != null);
		super.update();
		
		//updatePathing();
		action();
		sightCollider.clear();
		sightCollider.updateXY(x, y);
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
			playstate.add(new HeartCollectible(playstate, x, y));
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
	
	public function set_velocity(value:FlxPoint):FlxPoint
	{
		sprite.velocity.x = value.x;
		sprite.velocity.y = value.y;
		return value;
	}
}
