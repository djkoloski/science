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
	var wanderAction:Dynamic; 
	
	public function new(X:Float=200, Y:Float=200,spritefilename:String=null) 
	{
		super(X, Y, spritefilename);
		
		wanderAction = function() {
		if (destination == null) {
			destination = new Vector2(Math.random() * 70 - 35 + x, Math.random() * 70 - 35 + y);
		}
		if (goTo()) {
			destination = null;
		}
	};
		action = wanderAction;
	}
	
}