package;

import flixel.FlxSprite;
//import lime.math.Vector2;
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.util.FlxPoint;

/**
 * 
 */
class Mob extends FlxSprite
{
//	var collider:Collider;
	
	public var speed:Int;
	public var target:FlxSprite;
	public var action:Dynamic;
	public var destination:FlxPoint;
	public var playstate:PlayState;
	
	
	public var followDistance:Int;
	
	public var idleAction = function() { };
	
	public function goTo(point:FlxPoint): Bool {
		//Moves towards target point, returning true if it has arrived. 
		moveTowards(point);
		if (distanceTo(point) < speed * FlxG.elapsed) {
			trace("distance to dest: " + distanceTo(destination) + " speed: " +  (speed * FlxG.elapsed));
			return true;
		}
		return false;
	}
	
	
	public var path:Array<FlxPoint>;
	public function pathTo(point:FlxPoint): Bool {
		//Paths towards the given point, returning true if it has arrived, false otherwise.
		if (path == null || path[path.length - 1] != point) {
			trace("path is not valid");
			path = playstate.level.foregroundTiles[0].findPath(new FlxPoint(x, y), new FlxPoint(point.x, point.y));
			if (path == null || path.length == 0) {
				path = null;
				return true;
			}
		}
		trace("path is valid");
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
		
		followDistance = 100;
		speed = 50;
	}
	
	public function mobReset():Void {
		action = idleAction;
	}
	
	
	
	public function stopShort(point:FlxPoint):FlxPoint {
		//returns a point that is followdistance away from point. If closer than followdistance, it will return the current position.
		var temp :FlxPoint = towards(point);
		var dist :Float = distanceTo(point);
		return new FlxPoint(x + Math.max(temp.x * (dist - followDistance),0), y + Math.max(temp.y * (dist - followDistance),0));
	}
	
	public function distanceTo(point:FlxPoint):Float {
		return Math.sqrt(  (x - point.x)  * (x - point.x)  + (y - point.y) * (y - point.y));
	}
	public override function update():Void {
		super.update();
		action();
	}
	
	public function towards(point:FlxPoint):FlxPoint {
		//returns a normalized FlxPoint in the direction of point.
		var tempx = point.x - x;
		var tempy = point.y - y;
		var len:Float = Math.sqrt( tempx * tempx + tempy * tempy);
		//trace("direction: " + (tempx / len) + "," + (tempy / len));
		return new FlxPoint(tempx / len, tempy / len);
	}
	
	public function moveTowards(point:FlxPoint):Void {
		var dir = towards(destination);
		x += dir.x * speed * FlxG.elapsed;
		y += dir.y * speed * FlxG.elapsed;
		//trace("moving towards " + point.x + "," + point.y);
	}
}