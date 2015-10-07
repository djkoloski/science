package;

import flixel.FlxSprite;
//import lime.math.Vector2;
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.util.FlxPoint;

/**
 * 
 */
class Mob extends FlxSprite implements Damageable
{
//	var collider:Collider;
	
	public var speed:Int;
	public var target:FlxSprite;
	public var action:Dynamic;
	public var destination:FlxPoint;
	public var playstate:PlayState;
	
	public var weapon:WeaponManager;
	//public var weaponType:WeaponType = WeaponType_Bullet1;
	
	
	public var followDistance:Int;
	
	public var idleAction = function() { };
	
	public function goTo(point:FlxPoint): Bool {
		//Moves towards target point, returning true if it has arrived. 
		Assert.info(point.x > 0 && point.y > 0,"Something is moving to a point offscreen.");
		moveTowards(point);
		//trace("distance to dest: " + distanceTo(point) + " speed: " +  (speed * FlxG.elapsed));
		//trace("point: " + point.toString());
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
			
			//trace("going from: " + x + "," + y + " to: " + point.x + "," + point.y);
			path = playstate.level.foregroundTiles.findPath(new FlxPoint(x, y), new FlxPoint(point.x, point.y));
			if (path == null) {
			//	trace("there is no path.");
			}
			if (path == null || path.length == 0) {
				path = null;
				return true;
			}
		}
		if (path.length == 0) {
			path = null;
			return true;
		}
		//for (point in path) {
		//	trace(point.toString());
		//}
		//trace("path is valid");
		//trace(path[0].toString() + " isthe destination and we are at " + x + "," + y);
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
		var angle:Float = Math.atan2(velocities.y,velocities.x);
		weapon.fire(x, y, angle);
	}
	
	public function getTarget() {
		target = playstate.player;
	}
	
	//public function follow():Bool {
		//Should only be called after a successful gettarget call.
	//	Assert.info(target != null);
	//	if (distanceTo(new FlxPoint(target.x, target.y)) > followDistance) {
			
	//	}
	//}
	
	public function new(playstate:PlayState, X:Float = 200, Y:Float = 200,spritefilename:String=null) {
		//loadGraphic(spritefile,
		super(X, Y);
		this.playstate = playstate;
		playstate.damagables.add(this);
		if (spritefilename == null) {
			spritefilename = "assets/images/linda.png";
			trace("filename is now " + spritefilename);
		}
		//loadGraphic("assets/images/linda.png", true, 16, 16);
		//animation.add("idle", [0]);
		//animation.play("idle");
		
		this.makeGraphic(32, 32, FlxColor.GREEN);
		updateHitbox();
	//	collider = new Collider(x,y);
		//this.addChild(collider);
		action = idleAction;
		
		weapon = new WeaponManager(playstate, WeaponType_Bullet2);
		followDistance = 100;
		speed = 50;
	}
	
	public function takeDamage(damage:Int) {
		trace("taking " + damage + " damage");
	}
	
	public function mobReset():Void {
		action = idleAction;
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
	
	public override function update():Void {
		super.update();
		action();
		weapon.update();
	}
	
	
	public function towardsSprite(sprite:FlxSprite):FlxPoint {
		//towards for a sprite..
		return towards(new FlxPoint(sprite.x, sprite.y));
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
		x += dir.x * speed * FlxG.elapsed;
		y += dir.y * speed * FlxG.elapsed;
		
		Assert.info(!Math.isNaN(x) && !Math.isNaN(y));
		//trace("moving towards " + point.x + "," + point.y);
	}
}