package;
import flixel.util.FlxPoint;
import collision.DamageMask;
import weapon.PodGun;

/**
 * ...
 * @author ...
 */
class PodEnemy extends Testenemy
{

	var protectAction:Dynamic;
	var exploreAction:Dynamic;
	
	var assistAction:Dynamic;
	var attackAction:Dynamic;
	
	var hive:HiveEnemy;
	
	public function new(playstate:PlayState, startX:Float=200, startY:Float=200, hive, damageMask:Int=DamageMask.POD) 
	{
		super(playstate, startX, startY, damageMask);
		weapon = new PodGun(playstate);
		speed = 150;
		this.hive = hive;
		hive.addPod(this);
		heartChance = .5;
		
		this.sprite.loadGraphic(AssetPaths.squid_walk__png, true, 32, 64);
		this.sprite.animation.add("right", [4, 5], 10, false);
		this.sprite.animation.add("up", [2, 3], 10, false);
		this.sprite.animation.add("left", [6, 7], 10, false);
		this.sprite.animation.add("down", [0, 1], 10, false);
		
		
		
		sprite.setGraphicSize( -1, 32);
		
		protectAction = function() {
			//The pod will go to the hive and defend it.
			if (hive == null) {
				//..unless there is no hive.
				//target = null;
				//action = exploreAction;
				explore();
				return;
			}
			if (target == null || !target.exists) {
				if (!getTarget()) {
					//keeps getting new targets until there are none around, then goes back to exploring.
					//action = exploreAction;
					explore();
					hive.calm();
					return;
				}
			}
			if (destination == null || pathTo(destination)) {
				//To make a sort of 'swarming' behavior, they don't simply follow the hive but fly around it at random.
				destination = stopShort(new FlxPoint(hive.x, hive.y));
				destination.x += 50 - Math.random() * 100;
				destination.y += 50 - Math.random() * 100;
				
			}
			fire();
		};
		
		exploreAction = function() {
			//The pod will wander randomly. It might attack someone nearby but it has a very low chance of doing so. 
			if (Math.random() > .9999) {
				if (getTarget()) {
					Trace.info("attacking from explore");
					attack();
					//action = attackAction;
					return;
				}
			}
			if (destination == null || pathTo(destination)) {
				destination = new FlxPoint(x + 500 - Math.random() * 1000, y + 500 - Math.random() * 1000);
			}
		};
		
		assistAction = function() {
			
			if (target == null || !target.exists) {
				//If the target is null that means the ally that it is assisting is dead. It will be hostile to anyone nearby.
				if (destination == null) {
					explore();
//					action = exploreAction;
					return;
				}
				if (getTarget()) {
					attack();
					return;
//					action = attackAction;
				}
			}
			if (destination == null) {
				destination = stopShort(new FlxPoint(target.x, target.y));
			}
			if (pathTo(destination)) {
				if (getTarget()) {
					attack();
					//action = attackAction;
					return;
				}else {
					explore();
//					action = exploreAction;
					return;
				}
			}
		};
		
		idleAction = function() {
			
			//Trace.info("idle");
			lastFramePos = null;
			explore();
		}
		
		attackAction = function() {
			velocity = new FlxPoint(0, 0);
			if (target == null|| !target.exists) {
				if (!getTarget()) {
					explore();
					return;
//					action = exploreAction;
				}
			}
			if (Math.random() > .95)  {
				destination = stopShort(new FlxPoint(target.get_x(), target.get_y()));
			}
			if (destination == null) {
				
			}else{
				if (pathTo(destination)) {
					destination = null;
				};
			}
			/*
			if (destination == null || Math.random() > .95)  {
				destination = stopShort(new FlxPoint(target.get_x(), target.get_y()));
			}
			if (pathTo(destination)) {
				destination = null;
			};
			*/
			fire();
		};
		explore();
		//action = exploreAction;
	}
	
	public function assist(target:PodEnemy) {
		
		//Trace.info("assisting");
		this.target = target;
		destination = null;
		action = assistAction;
	}
	
	public function defend() {
		
		//Trace.info("defending");
		action = protectAction;
		destination = null;
	}
	
	public function attack(source:Int=null) {
		
		//Trace.info("attacking");
		if (source != null) {
			getTarget(source);
		}else {
			target = null;
		}
		action = attackAction;
	}
	
	public function explore() {
		
		//Trace.info("exploring");
		action = exploreAction;
		target = null;
		destination = null;
	}
	
	public override function destroy() {
		hive.deathNotice(this);
		super.destroy();
	}
	
	public override function receiveDamage(amount:Int,source:Int):Void
	{
		super.receiveDamage(amount,source);
		hive.alert(this);
		attack(source);
		//action = attackAction;
		//destination = null;
	}
	
	public override function update():Void
	{
		super.update();
		updateAnimation();
	}
	
	public override function updateAnimation():Void
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
