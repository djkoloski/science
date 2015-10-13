package;
//import lime.math.Vector2;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxPoint;
import collision.DamageMask;
import weapon.TankGun;

/**
 * ...
 * @author ...
 */
class Testenemy extends Mob
{
	//var idleAction:Dynamic; 
	var chaseAction:Dynamic;
	public function new(playstate:PlayState, startX:Float=200, startY:Float=200, damageMask:Int = DamageMask.ENEMY, spritePath:String = null)
	{
		super(playstate, startX, startY,damageMask, spritePath);
		weapon = new TankGun(playstate);
		//target = playstate.player;
		
		idleAction = function() {
			if (getTarget()) {
				action = chaseAction;
			}
		};
		
		
		
		chaseAction = function() {
			if (target == null) {
				action = idleAction;
				return;
			}
			if (destination == null || Math.random() > .95)  {
			//	trace("dest is null");
				//trace(target);
				//trace(target.get_x() + ", " + target.get_y());
				//trace(target);
				destination = stopShort(new FlxPoint(target.get_x(), target.get_y()));
				//as is, the path is recalculated every frame the player moves.
			}
			if (pathTo(destination)) {
			//	trace("successful path");
				destination = null;
			};
			fire();
		};
		
		action = chaseAction;
	}
	public override function receiveDamage(amount:Int):Void
	{
		super.receiveDamage(amount);
		getTarget();
		action = chaseAction;
		
		//action = attackAction;
		//destination = null;
	}
}