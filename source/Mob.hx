package;

import collision.IDamageable;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.util.FlxColor;
import flixel.util.FlxPoint;
import weapon.Weapon;

import collision.DamageMask;
import collision.ICollidable;
import collision.IHittable;
import collision.DamageableSprite;
import collision.Collision;
import collision.CollisionFlags;

class Mob extends FlxGroup implements IHittable
{
	public var playstate:PlayState;
	
	
	public var velocities:FlxPoint;
	public var weaponRadius:Float;
	
	public var stats:Stats;
	public var speed:Float;
	public var target:Dynamic;
	public var maximumDistance:Float;
	public var minimumDistance:Float;
	public var weapon:weapon.Weapon;
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
	
	
	public var damageMask:Int;
	public var idleAction:Dynamic;
	
	private var lastFramePos:FlxPoint;
	
	//public var hud:MobHUD;
	//public var stats:Stats;
	
	
	public function new(playstate:PlayState, startX:Float, startY:Float, damageMask:Int)
	{
		super();
		sightRadius = 10;
		followDistance = 100;
		this.damageMask = damageMask;
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
		//this.weapon = new weapon.PodGun(playstate);
		
		this.sprite = new DamageableSprite(startX, startY);
		this.sprite.setProxy(this);
		this.sprite.makeGraphic(32, 32, FlxColor.GREEN);
		
		this.hud = new MobHUD(this);
		sightCollider = new OverlapSquare(x - (sightRadius / 2), y - (sightRadius / 2), sightRadius, sightRadius);
		add(sightCollider);
		this.playstate.collision.add(sightCollider);
		
		//add(this.weapon);
		add(this.sprite);
		this.playstate.collision.add(this.sprite);
		add(this.hud);
		
		idleAction= function() {
			this.velocity = new FlxPoint(0, 0);
		};
		//sprite.immovable = true;
	}
	
	public function stun(velocity:FlxPoint):Void {
		return;	
	}
	
	public function goTo(point:FlxPoint): Bool {
		//Moves towards target point, returning true if it has arrived. 
		Assert.info(point.x > 0 && point.y > 0, "Something is moving to a point offscreen.");
		//trace("going to");
		moveTowards(point);
		if (distanceTo(point) < speed * FlxG.elapsed || getCenter().distanceTo(point) < sprite.width) {
			return true;
		}
		return false;
	}
	
	
	public var path:Array<FlxPoint>;
	public function pathTo(point:FlxPoint): Bool {
		//Paths towards the given point, returning true if it has arrived, false otherwise. CALLED EVERY FRAME.
		
		if (path == null ||  path[path.length - 1].x != point.x || path[path.length - 1].y != point.y) {
			//If we need to make a new path (no path or new destination is different from the old one)...
			//trace("path is not valid");
			//var other =  new FlxPoint(point.x, point.y);
			//trace("going from: " + x + "," + y + " to: " + point.x + "," + point.y);
			if (!playstate.level.foreground.getBounds().containsFlxPoint(point)) {
				//If the path end is outside of the level this path is over. 
				//trace("path outside of level");
				return true;
			}
			path = playstate.level.foreground.findPath(new FlxPoint(x, y), point);
			
			
			
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
			/*trace("From");
			for (point in path) {
				trace(point.toString());
			}
			trace("to"); 
			for (i in 0...path.length) {
				path[i] = new FlxPoint(path[i].x - sprite.width / 2, path[i].y - sprite.height / 2);
			}
			for (point in path) {
				trace(point.toString());
			}*/
		}
		//trace("reaches 2");
		if (path.length == 0) {
			trace("path length 0");
			path = null;
			return true;
		}
		if (goTo(path[0])) {
			//If we've reached the current node of the path...
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
		//if (!target.exists) {
		//	target = null;
		//	return;
		//}
		Assert.info(target != null);
/*<<<<<<< HEAD
		Assert.info(target.exists);
		//trace(target);
		//trace("firing");
		var velocities:FlxPoint = towardsSprite(target);
		var angle:Float = Math.atan2(velocities.y, velocities.x);
		//trace(angle);
		weapon.fire(x, y, angle);
=======*/
		//trace(target);
		//trace("firing");
		//trace(angle);
		weapon.fire();
//>>>>>>> 0654c8c8a86190f9268a22e89a638d6ae8be3bfd
	}
	
	
	public function getTarget(source:Int=null) {
		for (obj in sightCollider.getCollisionList()) {
			if (obj.getDamageableMask() != this.getDamageableMask()) {
				if (!(cast obj).exists) {
					//Assert.info(false);
					
					continue;
				}
				if (source != null) {
					if(obj.getDamageableMask() == source){
						target = obj;
						return true;
					}
				}else {
					target = obj;
					return true;
				}
			}
		}
		if (source != null) {
			return getTarget();
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
		//To keep the AI from getting stuck on walls so much, movetowards converts the destination so that the middle of the AI will aim for it, not the top left corner.
		Assert.info(!Math.isNaN(point.x) && !Math.isNaN(point.y));
		Assert.info(!Math.isNaN(x) && !Math.isNaN(y));
		if (point.x == x && point.y == y) {
			this.velocity = new FlxPoint(0, 0);
			return;
		}
		
		
		/*if (lastFramePos != null && lastFramePos.x - x < speed/10000 && lastFramePos.y - y < speed/10000) {
			stuck();
			return;
		}*/
		/*if ( new FlxPoint(x, y) == new FlxPoint(x, y)) {
			trace("equals works as expected");
		}*/
		if(Math.random() > .95){
			lastFramePos = new FlxPoint(x, y);
		}
		//var dir = towards(point);
		var dir = towards(new FlxPoint(point.x - sprite.width / 2, point.y - sprite.height / 2));
		if (Math.abs(dir.x) > Math.abs(dir.y)) {
			//moving more in the leftright direction
			if (dir.x > 0) {
				sprite.animation.play("right");
			}else {
				sprite.animation.play("left");
			}
		}else {
			//moving more in the updown direction
			if (dir.y < 0) {
				sprite.animation.play("up");
			}else {
				sprite.animation.play("down");
			}
		}
		//dir = new FlxPoint(dir - sprite.width / 2, dir - sprite.height / 2);
		this.velocity = new FlxPoint(dir.x * speed, dir.y * speed);
		//x += dir.x * speed * FlxG.elapsed;
		//y += dir.y * speed * FlxG.elapsed;
		Assert.info(!Math.isNaN(this.velocity.x) && !Math.isNaN(this.velocity.y));
		//trace("moving towards " + point.x + "," + point.y);
	}
	
	public function getCenter():FlxPoint {
		return new FlxPoint(x + width / 2, y + width / 2);
	}
	
	public override function draw():Void {
		super.draw();
		
		hud.draw();
	}
	public function stuck() {
		action = idleAction;
	}
	

	public override function update()
	{
		Assert.info(action != null);
		super.update();
		
		if (target != null && target.exists)
		{
			//Assert.info(target.exists);
			velocities = towardsSprite(target);
			weaponRadius = Math.sqrt(Math.pow(sprite.width / 2, 2) + Math.pow(sprite.height / 2, 2));
			weapon.setTransform(x + sprite.width / 2, y + sprite.width / 2, velocities.x, velocities.y, weaponRadius);
		}
		
		//updatePathing();
		action();
		sightCollider.clear();
		sightCollider.updateXY(x, y);
		stats.update();
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
			Collision.separate.bind(this.sprite, cast other),
			// Let damagers assign damage
			null,
			null
		);
	}
	
	public function getDamageableMask():Int
	{
		return damageMask;
	}
	
	public function receiveDamage(amount:Int,source:Int):Void
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
		//sprite.velocity = value;
		sprite.velocity.x = value.x;
		sprite.velocity.y = value.y;
		return value;
	}
}
