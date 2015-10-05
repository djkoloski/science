package;

import flixel.FlxSprite;
import lime.math.Vector2;
import flixel.FlxG;
import flixel.util.FlxColor;

/**
 * 
 */
class Mob extends FlxSprite
{
//	var collider:Collider;
	
	public var speed:Int;
	public var target:FlxSprite;
	public var action:Dynamic;
	public var getTarget:Dynamic = function() { };
	public var destination:Vector2;
	
	public var idleAction = function() { };
	
	public function goTo() :Bool {
		//Moves towards destination, returning true if it has arrived. 
		moveTowards(destination);
		if (distanceTo(destination) < speed * FlxG.elapsed) {
			trace("distance to dest: " + distanceTo(destination) + " speed: " +  (speed * FlxG.elapsed));
			return true;
		}
		return false;
	}
	
	
	public function new(X:Float = 200, Y:Float = 200,spritefilename:String=null) {
		//loadGraphic(spritefile,
		super(X, Y);
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
		
		speed = 50;
		
		
	}
	
	public function mobReset():Void {
		action = idleAction;
	}
	
	
	public function distanceTo(point:Vector2):Float {
		return Math.sqrt(  (x - point.x)  * (x - point.x)  + (y - point.y) * (y - point.y));
	}
	public override function update():Void {
		super.update();
		//getTarget();
		//if (target) {
		action();
		//}else {
		//	reset();
		//}
	}
	
	public function towards(point:Vector2):Vector2 {
		//returns a normalized vector in the direction of point.
		var tempx = point.x - x;
		var tempy = point.y - y;
		var len:Float = Math.sqrt( tempx * tempx + tempy * tempy);
		trace("direction: " + (tempx / len) + "," + (tempy / len));
		return new Vector2(tempx / len, tempy / len);
	}
	
	public function moveTowards(point:Vector2):Void {
		var dir = towards(destination);
		x += dir.x * speed * FlxG.elapsed;
		y += dir.y * speed * FlxG.elapsed;
		trace("moving towards " + point.x + "," + point.y);
	}
}