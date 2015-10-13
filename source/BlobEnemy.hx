package;
import collision.DamageMask;
import flixel.util.FlxPoint;
import flixel.util.FlxVector;
/**
 * ...
 * @author ...
 */
class BlobEnemy extends Testenemy
{
	
	
	//var chaseAction:Dynamic;
	var splitRadius:Int = 1000;
	var scaleFactor:Float;
	
	var jumpAction:Dynamic;
	var sitAction:Dynamic;
	
	var splitAction:Dynamic;
	var timer:Int;
	var jumpTime:Int = 10;
	var sitTime:Int = 100;
	
	public function new(playstate:PlayState, startX:Float, startY:Float,maxHearts:Int = 3,scaleFactor:Float = 1)//, damageMask:Int = DamageMask.ENEMY, spritePath:String = null) 
	{
		
		this.maxHearts = maxHearts;
		super(playstate, startX, startY,  DamageMask.ENEMY, null);
		this.scaleFactor = scaleFactor;
		this.sprite.scale.x = scaleFactor;
		this.sprite.scale.y = scaleFactor;//(new FlxPoint(scaleFactor, scaleFactor));
		this.sprite.updateHitbox();
		
		speed = 300;
		weapon = new weapon.BlobGun(playstate);
		
		idleAction = function() {
			if (getTarget()) {
				lastFramePos = null;
				action = jumpAction;
			}
		};
		
		
		
		timer = Math.floor(Math.random() * 20);
		jumpAction = function() {
			if (target == null || !target.exists) {
				action = idleAction;
				return;
			}
			if (destination == null) {
				sit();
			}
			if (pathTo(destination)) {
				sit();
			}
			fire();
			//chaseAction();
			timer -= 1;
			if (timer <= 0) {
				sit();
			}
		}
		
		splitAction = function() {
			var temp = speed;
			speed = splitRadius;
			moveTowards(destination);
			action = sitAction;
			speed = temp;
		};
		
		sitAction = function() {
			if (target == null|| !target.exists) {
				getTarget();
				return;
			}
			this.velocity = new FlxPoint(0, 0);
			fire();
			timer -= 1;
			if (timer <= 0) {
				jump();
			}
		}
		action = sitAction;
	}
	
	public function sit() {
		timer = Math.floor(Math.random() * 20) + sitTime;
		action = sitAction;
	}
	
	public function jump() {
		destination = stopShort(new FlxPoint(target.get_x(), target.get_y()));
		timer =Math.floor(Math.random() * 20) + jumpTime;
		action = jumpAction;
	}

	public override function receiveDamage(amount:Int,source:Int):Void
	{
		getTarget(source);
		sit();		
		stats.damage(amount);
		if (stats.isDead())
		{
			if (maxHearts > 1) {
				for ( i in 0...3) {
					var blob = new BlobEnemy(playstate, x, y, maxHearts - 1, scaleFactor * .6);
					//blob.velocity = new FlxVector(Math.random() * splitRadius * 2 - splitRadius, Math.random() * splitRadius * 2 - splitRadius);
					//blob.action = idleAction;
					blob.destination = new FlxVector(x + Math.random() * splitRadius * 2 - splitRadius, y + Math.random() * splitRadius * 2 - splitRadius);
					//action = jump;
					playstate.add(blob);
					blob.action = blob.splitAction;
				}
			}
			destroy();
			playstate.add(new HeartCollectible(playstate, x, y));
		}
	}
	/*
	public override function destroy():Void {
		
		super.destroy();
	}*/
	
	/*public override function receiveDamage(amount:Int,source:Int):Void
	{
		super.receiveDamage(amount,source);
		
		//action = attackAction;
		//destination = null;
	}*/
	
}