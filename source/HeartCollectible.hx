package;

class HeartCollectible extends Collectible
{
	private var heal:Int;
	
	public function new(state:PlayState, x:Float, y:Float, h:Int = 1) 
	{
		super(state, x, y, "assets/images/heartpickup.png");
		heal = h;
	}
	
	public override function onCollect():Void
	{
		state.player.stats.addHearts(heal);
		destroy();
	}
}