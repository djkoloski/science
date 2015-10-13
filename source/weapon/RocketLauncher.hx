package weapon;
import collision.DamageMask;
import flixel.util.FlxColor;
/**
 * ...
 * @author ...
 */
class RocketLauncher extends Gun
{

	//public var cooldownTimer:Float;
	public var reloadTime:Float = 10;
	public var bulletSize:Float = 8;
	public var lifespan:Float = 3;
	public var speed:Float = 1500;
	public var color:Int = FlxColor.RED;
	public var amount:Int = 50;
	public function new(state:PlayState)//, damageMask:Int, cooldownPerShot:Float, bulletRadius:Float, bulletLifespan:Float, bulletSpeed:Float, bulletColor:Int) 
	{
		state.add(this);
		super(state, DamageMask.PLAYER, reloadTime, bulletSize, lifespan, speed, amount, color);
		
	}
	
}