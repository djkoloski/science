package;
import collision.DamageMask;
import flixel.util.FlxPoint;
import flixel.util.FlxVector;
import collision.CollisionFlags;
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
	
	public function new(playstate:PlayState, startX:Float, startY:Float,maxHearts:Int = 2,scaleFactor:Float = 1)//, damageMask:Int = DamageMask.ENEMY, spritePath:String = null) 
	{
		
		this.maxHearts = maxHearts;
		super(playstate, startX, startY,  DamageMask.ENEMY);
		this.scaleFactor = scaleFactor;
		heartChance = .1;
		sightRadius = 250;
		
		stats.hearts = maxHearts;
		stats.residualMax = 15;
		stats.regen = 10;
		
		
		this.sprite.loadGraphic(AssetPaths.blob_walk__png, true, 32, 32);
		this.sprite.animation.add("right", [0, 1], 10, false);
		this.sprite.animation.add("up", [2, 3], 10, false);
		this.sprite.animation.add("left", [4, 5], 10, false);
		this.sprite.animation.add("down", [6, 7], 10, false);
		this.sprite.scale.x = scaleFactor;
		this.sprite.scale.y = scaleFactor;
		this.sprite.updateHitbox();
		this.sprite.drag.x = 5000;
		this.sprite.drag.y = 5000;
		
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
	}/*
	public override function getCollisionFlags():Int
	{
		return CollisionFlags.NONE;
	}*/
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
					//playstate.necessaryMobs.push(blob);
					blob.action = blob.splitAction;
				}
			}
			playstate.necessaryMobs.remove(this);
			destroy();
			if (Math.random() < heartChance) {
				playstate.add(new HeartCollectible(playstate, x, y));
			}
		}
	}
}