package;
import flixel.util.FlxPoint;
import collision.DamageMask;
import weapon.PodGun;

/**
 * ...
 * @author ...
 */
class PodEnemy extends Testenemy
{

	var protectAction:Dynamic;
	var exploreAction:Dynamic;
	
	var assistAction:Dynamic;
	var attackAction:Dynamic;
	
	var hive:HiveEnemy;
	
	public function new(playstate:PlayState, startX:Float=200, startY:Float=200, hive, damageMask:Int=DamageMask.ENEMY) 
	{
		super(playstate, startX, startY, damageMask);
		weapon = new PodGun(playstate);
		speed = 150;
		this.hive = hive;
		hive.addPod(this);
		protectAction = function() {
			//The pod will go to the hive and defend it.
			if (hive == null) {
				//..unless there is no hive.
				//target = null;
				//action = exploreAction;
				explore();
				return;
			}
			if (target == null) {
				if (!getTarget()) {
					//keeps getting new targets until there are none around, then goes back to exploring.
					//action = exploreAction;
					explore();
					hive.calm();
					return;
				}
			}
			if (destination == null || pathTo(destination)) {
				//To make a sort of 'swarming' behavior, they don't simply follow the hive but fly around it at random.
				destination = stopShort(new FlxPoint(hive.x, hive.y));
				destination.x += 50 - Math.random() * 100;
				destination.y += 50 - Math.random() * 100;
				
			}
			fire();
		};
		
		exploreAction = function() {
			//The pod will wander randomly. It might attack someone nearby but it has a very low chance of doing so. 
			if (Math.random() > .9999) {
				if (getTarget()) {
					trace("attacking from explore");
					attack();
					//action = attackAction;
					return;
				}
			}
			if (destination == null || pathTo(destination)) {
				destination = new FlxPoint(x + 500 - Math.random() * 1000, y + 500 - Math.random() * 1000);
			}
		};
		
		assistAction = function() {
			
			if (target == null) {
				//If the target is null that means the ally that it is assisting is dead. It will be hostile to anyone nearby.
				if (destination == null) {
					explore();
//					action = exploreAction;
					return;
				}
				if (getTarget()) {
					attack();
					return;
//					action = attackAction;
				}
			}
			if (destination == null) {
				destination = stopShort(new FlxPoint(target.x, target.y));
			}
			if (pathTo(destination)) {
				if (getTarget()) {
					attack();
					//action = attackAction;
					return;
				}else {
					explore();
//					action = exploreAction;
					return;
				}
			}
		};
		
		idleAction = function() {
			
			trace("idle");
			lastFramePos = null;
			explore();
		}
		
		attackAction = function() {
			if (target == null) {
				if (!getTarget()) {
					explore();
//					action = exploreAction;
				}
			}
			chaseAction();
		};
		explore();
		//action = exploreAction;
	}
	
	public function assist(target:PodEnemy) {
		
			trace("assisting");
		this.target = target;
		destination = null;
		action = assistAction;
	}
	
	public function defend() {
		
			trace("defending");
		action = protectAction;
		destination = null;
	}
	
	public function attack() {
		
		trace("exploring");
		action = attackAction;
		target = null;	
	}
	
	public function explore() {
		
		trace("exploring");
		action = exploreAction;
		target = null;
		destination = null;
	}
	
	public override function destroy() {
		hive.deathNotice(this);
		super.destroy();
	}
	
	public override function receiveDamage(amount:Int):Void
	{
		super.receiveDamage(amount);
		hive.alert(this);
		attack();
		//action = attackAction;
		//destination = null;
	}
}
