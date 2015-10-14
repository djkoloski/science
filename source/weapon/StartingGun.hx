package weapon;
import collision.DamageMask;
import flixel.util.FlxColor;
/**
 * ...
 * @author ...
 */
class StartingGun extends Gun
{

	//public var cooldownTimer:Float;
	public var reloadTime:Float = .5;
	public var bulletSize:Float = 4;
	public var lifespan:Float = .3;
	public var speed:Float = 900;
	public var color:Int = FlxColor.RED;
	public var amount:Int = 15;
	public function new(state:PlayState)//, damageMask:Int, cooldownPerShot:Float, bulletRadius:Float, bulletLifespan:Float, bulletSpeed:Float, bulletColor:Int) 
	{
		state.add(this);
		super(state, DamageMask.PLAYER, reloadTime, bulletSize, lifespan, speed, amount, color);
		
	}
	
}