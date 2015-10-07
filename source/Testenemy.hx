package;
//import lime.math.Vector2;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxPoint;

/**
 * ...
 * @author ...
 */
class Testenemy extends Mob
{
	var wanderAction:Dynamic; 
	var chaseAction:Dynamic;
	
	public function new(playstate:PlayState, X:Float=200, Y:Float=200,spritefilename:String=null) 
	{
		super(playstate, X, Y, spritefilename);
		
		target = playstate.player;
		
		wanderAction = function() {
			if (destination == null) {
				destination = new FlxPoint(Math.random() * 70 - 35 + x, Math.random() * 70 - 35 + y);
			}
			if (goTo(destination)) {
				destination = null;
			}
		};
		
		chaseAction = function() {
			if (target == null) {
				trace("getting target");
				getTarget();
				return;
			}
			if (destination == null) {
				destination = stopShort(new FlxPoint(target.x, target.y));
				//as is, the path is recalculated every frame the player moves.
			}
			if (pathTo(destination)) {
				destination = null;
			};
			fire();
		};
		
		action = chaseAction;
	}
	
}