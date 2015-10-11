package;
import collision.DamageMask;
/**
 * ...
 * @author ...
 */
class BlobEnemy extends Mob
{

	public function new(playstate:PlayState, startX:Float, startY:Float, damageMask:Int = DamageMask.ENEMY, spritePath:String = null) 
	{
		super(playstate, startX, startY, damageMask, spritePath);
		
	}
	
}