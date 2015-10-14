package;

/**
 * ...
 * @author ...
 */
class MachineGunCollectible extends Collectible
{

	public function new(state:PlayState, x:Float, y:Float) 
	{
		super(state, x, y, AssetPaths.heartpickup__png);
	}
	
	public override function onCollect():Void
	{
		state.player.machineGun.locked = false;
		destroy();
	}
	
}