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
	
	private var hearts:Array<FlxSprite>;
	private var barBackground:FlxSprite;
	private var barForeground:FlxSprite;
	private var mobStat:Stats;
	
	public function goTo() :Bool {
		//Moves towards destination, returning true if it has arrived. 
		moveTowards(destination);
		if (distanceTo(destination) < speed * FlxG.elapsed) {
			return true;
		}
		return false;
	}
	
	
	public function new(X:Float = 200, Y:Float = 200,spritefilename:String=null) {
		//loadGraphic(spritefile,
		super(X, Y);
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
		
		speed = 50;
		
		mobStat = new Stats();
		
		hearts = [];
		for (i in 0...mobStat.getHearts()) {
			var h:FlxSprite = new FlxSprite(this.x + i*7, this.y - 20);
			h.makeGraphic(5, 5);
			hearts.push(h);
		}
		
		barBackground = new FlxSprite(this.x, this.y - 10);
		barBackground.makeGraphic(mobStat.getMaxResidual(), 5, 0xff000000);
		
		barForeground = new FlxSprite(this.x, this.y - 10);
		barForeground.makeGraphic(1, 5, 0xffff0000);
		barForeground.origin.x = barForeground.origin.y = 0;
		barForeground.scale.x = mobStat.getMaxResidual();
		
		mobStat.addResidual(20);
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
		
		barBackground.update();
		barForeground.update();
		barBackground.x = barForeground.x = this.x;
		barBackground.y = barForeground.y = this.y - 10;
		barForeground.scale.x = mobStat.getCurrentResidual();
		
		for (i in 0...mobStat.getHearts()) {
			hearts[i].update();
			hearts[i].x = this.x + i*7;
			hearts[i].y = this.y - 20;
		}
		
		mobStat.update();
	}
	
	public function towards(point:Vector2):Vector2 {
		//returns a normalized vector in the direction of point.
		var tempx = point.x - x;
		var tempy = point.y - y;
		var len:Float = Math.sqrt( tempx * tempx + tempy * tempy);
		return new Vector2(tempx / len, tempy / len);
	}
	
	public function moveTowards(point:Vector2):Void {
		var dir = towards(destination);
		x += dir.x * speed * FlxG.elapsed;
		y += dir.y * speed * FlxG.elapsed;
	}
	
	public override function draw():Void {
		super.draw();
		barBackground.draw();
		barForeground.draw();
		
		for (i in 0...mobStat.getHearts()) {
			hearts[i].draw();
		}
	}
}