package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.util.FlxColor;
import flixel.util.FlxPoint;

class Mob extends FlxGroup
{
	public var state:PlayState;
	
	public var speed:Float;
	public var target:FlxSprite;
	public var action:Dynamic;
	public var destination:FlxPoint;
	
	public var side:Side;
	public var weapon:WeaponManager;
	
	public var followDistance:Int;
	
	public var idleAction = function() { };
	
	public var hud:MobHUD;
	public var stats:Stats;
	
	public function goTo(point:FlxPoint): Bool {
		//Moves towards target point, returning true if it has arrived. 
		Assert.info(point.x > 0 && point.y > 0,"Something is moving to a point offscreen.");
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
	
	
	public function new(playstate:PlayState, X:Float = 200, Y:Float = 200,spritefilename:String=null) {
		//loadGraphic(spritefile,
		super(X, Y);
		this.playstate = playstate;
		playstate.damageables.add(this);
		if (spritefilename == null) {
			spritefilename = "assets/images/linda.png";
		}
		//loadGraphic("assets/images/linda.png", true, 16, 16);
		//animation.add("idle", [0]);
		//animation.play("idle");
		
		this.makeGraphic(32, 32, FlxColor.GREEN);
		updateHitbox();
	//	collider = new Collider(x,y);
		//this.addChild(collider);
		action = idleAction;
		
		weapon = new WeaponManager(playstate, side, WeaponType_Bullet2);
		followDistance = 100;
		speed = 50;
		
		stats = new Stats();
		hud = new MobHUD(this);
	}
	
	public function takeDamage(damage:Int) {
		// TODO: make the mob actually take damage
		//trace("taking " + damage + " damage");
		stats.damage(damage);
		if (stats.isDead()) {
			var hc:HeartCollectible = new HeartCollectible(this.x, this.y, 2);
			playstate.add(hc);
			playstate.collectibles.add(hc);
			this.destroy();
		}
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
		//}else {
		//	reset();
		//}
		
		stats.update();
		hud.update();
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
	
	public override function draw():Void {
		super.draw();
		
		hud.draw();
	}
}