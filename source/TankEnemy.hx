package;
import flixel.util.FlxPoint;
import collision.DamageMask;
/**
 * ...
 * @author ...
 */
class TankEnemy extends Testenemy
{
	public var fightAction:Dynamic;
	public var chargeAction:Dynamic;
	public var meleeRange:Int = 64;
	public var meleeWeapon:weapon.Weapon;
	public var rangedWeapon:weapon.Weapon;
	
	public function new(playstate:PlayState, startX:Float=200, startY:Float=200, damageMask:Int=DamageMask.ENEMY) 
	{
		super(playstate, startX, startY, damageMask);
		speed = 100;
		meleeWeapon = new weapon.TankMelee(playstate);
		rangedWeapon = weapon;
		
		this.sprite.loadGraphic(AssetPaths.tank_walk__png, true, 64, 64);
		this.sprite.animation.add("right", [0, 1,2,3], 10, false);
		this.sprite.animation.add("up", [4,5,6,7], 10, false);
		this.sprite.animation.add("left", [8,9,10,11], 10, false);
		this.sprite.animation.add("down", [12,13,14,15], 10, false);
		
		fightAction = function() {
			if (target == null || !target.exists) {
				action = idleAction;
			}
			//trace("fightaction");
			chaseAction();
			if(Math.random() > .99){
				var temp = new FlxPoint();
				playstate.level.foreground.raycast(new FlxPoint(x, y), towards(new FlxPoint(target.get_x(), target.get_y())), temp);
				if (distanceTo(temp) > distanceTo(new FlxPoint(target.get_x(), target.get_y()))) {
					charge(temp);
				}
			}
		}
		
		chargeAction = function() {
			if (target == null || !target.exists) {
				action = idleAction;
			}
			
			speed *= 5;
			if (goTo(destination)) {
				speed /= 5;
				attack();
				return;
			}
			speed /= 5;
			meleeWeapon.setTransform(x + sprite.width / 2, y + sprite.width / 2, velocities.x, velocities.y, weaponRadius);
			if (distanceTo( new FlxPoint(target.get_x(), target.get_y())) < meleeRange){
				meleeWeapon.fire();
				
				//fire();
			}else {
				trace("too far. distance is " + distanceTo( new FlxPoint(target.get_x(), target.get_y())));
			}
		}
		
		idleAction = function() {
			if (getTarget()) {
				action = fightAction;
			}
		}
	}
	
	public function charge(destination:FlxPoint) {
		this.destination = destination;
		action = chargeAction;
		trace("charging");
	}
	
	public function attack() {
		weapon = rangedWeapon;
		action = fightAction;
		trace("attacking");
	}
	
	public override function receiveDamage(amount:Int,source:Int):Void
	{
		super.receiveDamage(amount,source);
		getTarget(source);
		action = fightAction;
		
		//action = attackAction;
		//destination = null;
	}
	
}