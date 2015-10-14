package;
import collision.DamageMask;
/**
 * ...
 * @author ...
 */
class HiveEnemy extends Mob
{
	public var pods:Array<PodEnemy>;
	public var angry:Bool;
	
	public var totalPods:Int = 6;
	public var currentPods:Int = 6;
	public var deployedPods:Int = 0;
	
	public var manage:Dynamic;
	
	public function new(playstate:PlayState, startX:Float, startY:Float, damageMask:Int=DamageMask.POD) 
	{
		super(playstate, startX, startY, damageMask);
		pods = new Array<PodEnemy>();
		
		stats.hearts = 15;
		stats.residualMax = 45;
		stats.regen = 10;
		
		manage = function() {
			if (angry && currentPods > 0 && Math.random() > .95) {
				deploy();
			}
			if (deployedPods < currentPods) {
				deploy();
			}
			if (deployedPods + currentPods < totalPods && Math.random() > .9999) {
				Trace.info("making new pod");
				currentPods++;
			}
		}
		sprite.immovable = true;
		action = manage;
	}
	
	public function deathNotice(pod:PodEnemy) {
		Trace.info(pod);
		Assert.info(pods.remove(pod));
		deployedPods--;
		Assert.info(deployedPods == pods.length);
	}
	
	public function deploy() {
		Assert.info(currentPods > 0);
		currentPods--;
		var pod = new PodEnemy(playstate, x, y, this, this.getDamageableMask());
		playstate.add(pod);
		addPod(pod);
		if (angry) {
			pod.defend();
		}
	}
	
	public function addPod(pod:PodEnemy) {
		deployedPods++;
		pods.push(pod);
		Assert.info(pods.length == deployedPods);
	}
	
	public function alert(alarm:PodEnemy) {
		if (!angry) {
			for (pod in pods) {
				if (pod != alarm) {
					pod.assist(alarm);
				}
				
			}
		}
	}
	
	public function calm() {
		angry = false;
	}
	
	public override function receiveDamage(amount:Int,source:Int):Void
	{
		super.receiveDamage(amount,source);
		angry = true;
		for (pod in pods) {
			pod.defend();
		}
	}
	
}