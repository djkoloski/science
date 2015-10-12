package;
import collision.DamageMask;
/**
 * ...
 * @author ...
 */
class BlobEnemy extends Testenemy
{
	
	
	//var chaseAction:Dynamic;
	var splitRadius:Int = 50;
	public function new(playstate:PlayState, startX:Float, startY:Float,maxHearts:Int = 3)//, damageMask:Int = DamageMask.ENEMY, spritePath:String = null) 
	{
		
		this.maxHearts = maxHearts;
		super(playstate, startX, startY,  DamageMask.ENEMY, null);
	}

	public override function destroy():Void {
		if(maxHearts > 0){
			playstate.add(new BlobEnemy(playstate, x + Math.random() * splitRadius * 2 - splitRadius, y + Math.random() * splitRadius * 2 - splitRadius,maxHearts-1));
			playstate.add(new BlobEnemy(playstate, x + Math.random() * splitRadius * 2 - splitRadius, y + Math.random() * splitRadius * 2 - splitRadius,maxHearts-1));
			playstate.add(new BlobEnemy(playstate, x + Math.random() * splitRadius * 2 - splitRadius, y + Math.random() * splitRadius * 2 - splitRadius,maxHearts-1));
		}
		super.destroy();
	}
	
	
}