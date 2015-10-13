package weapon;
import collision.DamageMask;
import flixel.util.FlxColor;
/**
 * ...
 * @author ...
 */
class MachineGun extends Gun
{

	//public var cooldownTimer:Float;
	public var reloadTime:Float = .05;
	public var bulletSize:Float = 3;
	public var lifespan:Float = .5;
	public var speed:Float = 2000;
	public var color:Int = FlxColor.BLUE;
	public var amount:Int = 2;
	public function new(state:PlayState)//, damageMask:Int, cooldownPerShot:Float, bulletRadius:Float, bulletLifespan:Float, bulletSpeed:Float, bulletColor:Int) 
	{
		state.add(this);
		super(state, DamageMask.POD, reloadTime, bulletSize, lifespan, speed, amount, color);
		
	}
	
}