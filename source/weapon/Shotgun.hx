package weapon;
import collision.DamageMask;
import flixel.util.FlxColor;
/**
 * ...
 * @author ...
 */
class Shotgun extends Gun
{

	//public var cooldownTimer:Float;
	public var reloadTime:Float = .3;
	public var bulletSize:Float = 6;
	public var lifespan:Float = .3;
	public var speed:Float = 2500;
	public var color:Int = FlxColor.RED;
	public var amount:Int = 30;
	public function new(state:PlayState)//, damageMask:Int, cooldownPerShot:Float, bulletRadius:Float, bulletLifespan:Float, bulletSpeed:Float, bulletColor:Int) 
	{
		state.add(this);
		super(state, DamageMask.PLAYER, reloadTime, bulletSize, lifespan, speed, amount, color);
		
	}
	
}