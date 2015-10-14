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
	//public var sightCollider:OverlapSquare;
	
	public var sprite:DamageableSprite;
	public var hud:MobHUD;
	
	public var x(get, set):Float;
	public var y(get, set):Float;
	public var width(get, set):Float;
	public var height(get, set):Float;
	public var velocity(get, set):FlxPoint;
	
	public var maxHearts:Int;
	public var followDistance:Int;
	
	public var heartChance:Float = 1; 
	
	public var damageMask:Int;
	public var idleAction:Dynamic;
	
	private var lastFramePos:FlxPoint;
	
	public var necessary:Bool;
	
	//public var hud:MobHUD;
	//public var stats:Stats;
	
	
	public function new(playstate:PlayState, startX:Float, startY:Float, damageMask:Int)
	{
		super();
		sightRadius = 1000;
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
		//sightCollider = new OverlapSquare(x - (sightRadius / 2), y - (sightRadius / 2), sightRadius, sightRadius);
		//add(sightCollider);
		//this.playstate.collision.add(sightCollider);
		
		//add(this.weapon);
		add(this.sprite);
		this.playstate.collision.add(this.sprite);
		add(this.hud);
		
		playstate.enemies.push(this);
		
		idleAction= function() {
			this.velocity = new FlxPoint(0, 0);
		};
		//sprite.immovable = true;
		
		necessary = false;
	}
	
	public function stun(velocity:FlxPoint):Void {
		return;	
	}
	
	public function goTo(point:FlxPoint): Bool {
		//Moves towards target point, returning true if it has arrived. 
		Assert.info(point.x > 0 && point.y > 0, "Something is moving to a point offscreen.");
		//Trace.info("going to");
		moveTowards(point);
		if (distanceTo(point) < speed * FlxG.elapsed || distanceTo(point) < sprite.width * 2) {
			return true;
		}
		return false;
	}
	
	
	public var path:Array<FlxPoint>;
	public function pathTo(point:FlxPoint): Bool {
		//Paths towards the given point, returning true if it has arrived, false otherwise. CALLED EVERY FRAME.
		
		if (path == null ||  path[path.length - 1].x != point.x || path[path.length - 1].y != point.y) {
			//If we need to make a new path (no path or new destination is different from the old one)...
			//Trace.info("path is not valid");
			//var other =  new FlxPoint(point.x, point.y);
			//Trace.info("going from: " + x + "," + y + " to: " + point.x + "," + point.y);
			if (!playstate.level.foreground.getBounds().containsFlxPoint(point)) {
				//If the path end is outside of the level this path is over. 
				//Trace.info("path outside of level");
				return true;
			}
			path = playstate.level.foreground.findPath(new FlxPoint(x, y), point);
			
			
			
			//Trace.info("reaches here");
			//path = playstate.level.foreground.findPath(new FlxPoint(128, 128), new FlxPoint(256, 128));
			if (path == null) {
				//Trace.info("there is no path.");
			}
			if (path == null || path.length == 0) {
				//Trace.info("path length 0");
				path = null;
				return true;
			}
			/*Trace.info("From");
			for (point in path) {
				Trace.info(point.toString());
			}
			Trace.info("to"); 
			for (i in 0...path.length) {
				path[i] = new FlxPoint(path[i].x - sprite.width / 2, path[i].y - sprite.height / 2);
			}
			for (point in path) {
				Trace.info(point.toString());
			}*/
		}
		//Trace.info("reaches 2");
		if (path.length == 0) {
			Trace.info("path length 0");
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
		Assert.info(target != null);
		if (pointLineOfSight(new FlxPoint(target.get_x(), target.get_y()))) {
			weapon.fire();
		}else {
		}
	}
	
	
	
	public function getTarget(source:Int=null) {
		var temp = new FlxPoint();
		for (enemy in playstate.enemies) {
			if (source != null && enemy.getDamageableMask() != source) {
				continue;
			}
			if (enemy.getDamageableMask() == getDamageableMask()) {
				continue;
			}
			if (lineOfSight(enemy, temp) ) {
				if (getCenter().distanceTo(new FlxPoint((cast enemy).get_x(),(cast enemy).get_y())) < sightRadius) {
					target = enemy;
					return true;
				}
			}
		}
		if (source != null) {
			return getTarget(null);
		}
		return false;
	}
	
	
	public function stopShort(point:FlxPoint):FlxPoint {
		//returns a point that is followdistance away from point. If closer than followdistance, it will return the current position.
		if (pointLineOfSight(point)) {
			var temp :FlxPoint = towards(point);
			var dist :Float = distanceTo(point);
			return new FlxPoint(x + temp.x * (dist - followDistance), y + temp.y * (dist - followDistance));
		}
		return point;
	}
	
	public function pointLineOfSight(point:FlxPoint): Bool {
		var temp = new FlxPoint();
		playstate.level.foreground._raycast(new FlxPoint(x, y), towards(point), temp);
		if (distanceTo(temp) > distanceTo(point)) {
			return true;
		}
		return false;
	}
	
	public function lineOfSight(enemy:Dynamic,point:FlxPoint):Bool {
		var temp = new FlxPoint();
		playstate.level.foreground._raycast(new FlxPoint(x, y), towards(new FlxPoint(enemy.get_x(), enemy.get_y())), temp);
		if (distanceTo(temp) > distanceTo(new FlxPoint(enemy.get_x(), enemy.get_y()))) {
			//Trace.info("distance to temp: " + distanceTo(temp) + " distance to enemy xy "  + distanceTo(new FlxPoint(enemy.get_x(), enemy.get_y())));
			point.x = temp.x;
			point.y = temp.y;
			return true;
		}	
		return false;
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
		//Trace.info("direction: " + (tempx / len) + "," + (tempy / len));
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
			Trace.info("equals works as expected");
		}*/
		if(Math.random() > .95){
			lastFramePos = new FlxPoint(x, y);
		}
		//var dir = towards(point);
		//var dir = towards(new FlxPoint(point.x - sprite.width / 2, point.y - sprite.height / 2));
		var dir = towards(point);
		/*if (Math.abs(dir.x) > Math.abs(dir.y)) {
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
		}*/
		//dir = new FlxPoint(dir - sprite.width / 2, dir - sprite.height / 2);
		this.velocity = new FlxPoint(dir.x * speed, dir.y * speed);
		//x += dir.x * speed * FlxG.elapsed;
		//y += dir.y * speed * FlxG.elapsed;
		Assert.info(!Math.isNaN(this.velocity.x) && !Math.isNaN(this.velocity.y));
		//Trace.info("moving towards " + point.x + "," + point.y);
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
		//sightCollider.clear();
		//sightCollider.updateXY(x, y);
		stats.update();
	}
	
	public function getCollisionFlags():Int
	{
		return CollisionFlags.NOCUSTOM;
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
			playstate.enemies.remove(this);
			destroy();
			if (Math.random() < heartChance) {
				playstate.add(new HeartCollectible(playstate, x, y));
			}
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
	
	override public function destroy():Void 
	{
		playstate.necessaryMobs.remove(this);
		super.destroy();
	}
}
