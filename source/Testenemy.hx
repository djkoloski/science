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
	public function new(playstate:PlayState, startX:Float=200, startY:Float=200, damageMask:Int = DamageMask.ENEMY)
	{
		super(playstate, startX, startY,damageMask);
		weapon = new TankGun(playstate);
		//target = playstate.player;
		
		idleAction = function() {
			target = null;
			if (getTarget()) {
				action = chaseAction;
			}
		};
		
		
		
		chaseAction = function() {
			if (target == null || !target.exists) {
				action = idleAction;
				return;
			}
			if (destination == null || Math.random() > .95)  {
			//	Trace.info("dest is null");
				//Trace.info(target);
				//Trace.info(target.get_x() + ", " + target.get_y());
				//Trace.info(target);
				destination = stopShort(new FlxPoint(target.get_x(), target.get_y()));
				//as is, the path is recalculated every frame the player moves.
			}
			if (pathTo(destination)) {
				Trace.info("successful path");
				destination = null;
			};
			fire();
		};
		
		action = chaseAction;
	}
	public override function receiveDamage(amount:Int,source:Int):Void
	{
		super.receiveDamage(amount,source);
		getTarget(source);
		action = chaseAction;
		
		//action = attackAction;
		//destination = null;
	}
	
	public override function update():Void
	{
		super.update();
		updateAnimation();
	}
	
	public function updateAnimation():Void
	{
		if (Math.abs(velocity.x) >= Math.abs(velocity.y))
		{
			if (velocity.x > 0)
			{
				sprite.animation.play("right");
			}
			else
			{
				sprite.animation.play("left");
			}
		}
		else
		{
			if (velocity.y > 0)
			{
				sprite.animation.play("down");
			}
			else
			{
				sprite.animation.play("up");
			}
		}
	}
}