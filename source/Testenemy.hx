package;
import lime.math.Vector2;
import flixel.FlxG;
import flixel.FlxSprite;

/**
 * ...
 * @author ...
 */
class Testenemy extends Mob
{
	var wanderAction = function() {
		if (destination == null) {
			destination = new Vector2(Math.random() * 70 - 35 + x, Math.random() * 70 - 35 + y);
		}
		moveTwoards(destination);
	}
	
	public function new(X:Float=0, Y:Float=0, ?spritefile:Dynamic) 
	{
		super(X, Y, ?spritefile);
		idleAction;
		
	}
	
}