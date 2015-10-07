package;

/**
 * ...
 * @author ...
 */
class HeartCollectible extends Collectible
{
	
	private var heal:Int;

	public function new(x:Float, y:Float, h:Int = 10) 
	{
		super(x, y, "health");
		heal = h;
	}
	
	public function getHeal():Int 
	{
		return heal;
	}
	
	public function setHeal(h:Int):Void
	{
		heal = h;
	}
	
}