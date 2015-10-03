package;
import lime.math.Vector2;

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
		
	}
	
	public function new(X:Float=0, Y:Float=0, ?spritefile:Dynamic) 
	{
		super(X, Y, ?spritefile);
		idleAction = 
	}
	
}