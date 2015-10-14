package weapon;
import collision.DamageMask;
import flixel.util.FlxColor;
/**
 * ...
 * @author ...
 */
class TankMelee extends Gun
{

	//public var cooldownTimer:Float;
	public var reloadTime:Float = 3;
	public var bulletSize:Float = 64;
	public var lifespan:Float = .05;
	public var speed:Float = 300;
	public var color:Int = FlxColor.BLACK;
	public var amount:Int = 30;
	public function new(state:PlayState)//, damageMask:Int, cooldownPerShot:Float, bulletRadius:Float, bulletLifespan:Float, bulletSpeed:Float, bulletColor:Int) 
	{
		state.add(this);
		super(state, DamageMask.ENEMY, reloadTime, bulletSize, lifespan, speed, amount, color,"stun");
		
	}
	
}