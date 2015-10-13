package;
import collision.DamageMask;
import flixel.util.FlxPoint;
/**
 * ...
 * @author ...
 */
class BlobEnemy extends Testenemy
{
	
	
	//var chaseAction:Dynamic;
	var splitRadius:Int = 50;
	var scaleFactor:Float;
	
	var jumpAction:Dynamic;
	var sitAction:Dynamic;
	var timer:Int;
	var jumpTime:Int = 10;
	var sitTime:Int = 100;
	
	public function new(playstate:PlayState, startX:Float, startY:Float,maxHearts:Int = 3,scaleFactor:Float = 1)//, damageMask:Int = DamageMask.ENEMY, spritePath:String = null) 
	{
		
		this.maxHearts = maxHearts;
		super(playstate, startX, startY,  DamageMask.ENEMY);
		this.scaleFactor = scaleFactor;
		
		this.sprite.loadGraphic(AssetPaths.blob_walk__png, true, 32, 32);
		this.sprite.animation.add("right", [0, 1], 10, false);
		this.sprite.animation.add("up", [2, 3], 10, false);
		this.sprite.animation.add("left", [4, 5], 10, false);
		this.sprite.animation.add("down", [6, 7], 10, false);
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
		
		/*
		
		chaseAction = function() {
			if (target == null) {
				action = idleAction;
				return;
			}
			if (destination == null || Math.random() > .95)  {
			//	trace("dest is null");
				//trace(target);
				//trace(target.get_x() + ", " + target.get_y());
				trace(target);
				destination = stopShort(new FlxPoint(target.get_x(), target.get_y()));
			}
			if (pathTo(destination)) {
				destination = null;
			};
			fire();
		};
		*/
		
		
		timer = Math.floor(Math.random() * 20);
		jumpAction = function() {
			if (target == null) {
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
		
		sitAction = function() {
			if (target == null) {
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

	public override function destroy():Void {
		if (maxHearts > 0) {
			for ( i in 0...2) {
				var m:Mob = new BlobEnemy(playstate, x + Math.random() * splitRadius * 2 - splitRadius, y + Math.random() * splitRadius * 2 - splitRadius, maxHearts - 1, scaleFactor * .6);
				playstate.add(m);
				playstate.necessaryMobs.push(m);
			}
		}
		playstate.necessaryMobs.remove(this);
		super.destroy();
	}
	
	public override function receiveDamage(amount:Int):Void
	{
		super.receiveDamage(amount);
		getTarget();
		sit();		
		//action = attackAction;
		//destination = null;
	}
	
	public override function update():Void
	{
		super.update();
		updateAnimation();
	}
	
	public function updateAnimation():Void
	{
		if (Math.abs(velocity.x) >= Math.abs(velocity.y))
		{
			if (velocity.x > 0)
			{
				sprite.animation.play("right");
			}
			else
			{
				sprite.animation.play("left");
			}
		}
		else
		{
			if (velocity.y > 0)
			{
				sprite.animation.play("down");
			}
			else
			{
				sprite.animation.play("up");
			}
		}
	}
}