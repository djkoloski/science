package weapon;
import collision.DamageMask;
import flixel.util.FlxColor;
/**
 * ...
 * @author ...
 */
class BlobGun extends Gun
{

	//public var cooldownTimer:Float;
	public var reloadTime:Float = 4;
	public var bulletSize:Float = 3;
	public var lifespan:Float = .75;
	public var speed:Float = 600;
	public var color:Int = FlxColor.FOREST_GREEN;
	public var amount:Int = 5;
	public function new(state:PlayState)//, damageMask:Int, cooldownPerShot:Float, bulletRadius:Float, bulletLifespan:Float, bulletSpeed:Float, bulletColor:Int) 
	{
		state.add(this);
		super(state, DamageMask.ENEMY, reloadTime, bulletSize, lifespan, speed, amount, color);
		
	}
	
}