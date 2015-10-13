package weapon;
import collision.DamageMask;
import flixel.util.FlxColor;
/**
 * ...
 * @author ...
 */
class Sniper extends Gun
{

	//public var cooldownTimer:Float;
	public var reloadTime:Float = 2;
	public var bulletSize:Float = 2;
	public var lifespan:Float = 2;
	public var speed:Float = 1800;
	public var color:Int = FlxColor.RED;
	public var amount:Int = 45;
	public function new(state:PlayState)//, damageMask:Int, cooldownPerShot:Float, bulletRadius:Float, bulletLifespan:Float, bulletSpeed:Float, bulletColor:Int) 
	{
		state.add(this);
		super(state, DamageMask.PLAYER, reloadTime, bulletSize, lifespan, speed, amount, color);
		
	}
	
}