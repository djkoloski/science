package;

import flixel.FlxSprite;
import lime.math.Vector2;

/**
 * 
 */
class Mob extends FlxSprite
{
	var collider:Collider;
	
	var speed:Int;
	var target:FlxSprite;
	var action:Dynamic;
	var getTarget:Dynamic = function() { };
	var destination:Vector2;
	
	var idleAction = function() { };
	
	public function new(X:Float = 0, Y:Float = 0, ?spritefile:Dynamic) {
		//loadGraphic(spritefile,
		loadGraphic("assets/images/default enemy", true, 16, 16);
		animation.add("idle", [0]);
		super(X, Y, sprite);
		collider = new Collider(x,y);
		this.addChild(collider);
		action = idleAction;
		
		speed = 50;
		
		
	}
	
	public function reset() {
			action = idleAction();
	}
	
	public override function update():Void {
		getTarget();
		if (target) {
				action();
		}else {
			reset();
		}
	}
}