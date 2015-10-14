package weapon;
import collision.DamageMask;
import flixel.util.FlxColor;
/**
 * ...
 * @author ...
 */
class TankGun extends Gun
{

	//public var cooldownTimer:Float;
	public var reloadTime:Float = 1;
	public var bulletSize:Float = 5;
	public var lifespan:Float = .75;
	public var speed:Float = 800;
	public var color:Int = FlxColor.CHARTREUSE;
	public var amount:Int = 20;
	public function new(state:PlayState)//, damageMask:Int, cooldownPerShot:Float, bulletRadius:Float, bulletLifespan:Float, bulletSpeed:Float, bulletColor:Int) 
	{
		state.add(this);
		super(state, DamageMask.ENEMY, reloadTime, bulletSize, lifespan, speed, amount, color);
		
	}
	
}