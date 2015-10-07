package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;

class Bullet extends FlxSprite implements Damager
{
	public var lifespan:Float;
	public var dmg:Int = 5;
	public var side:Int;	
	
	public function new(startX:Float, startY:Float, movementAngle:Float, side:Int, radius:Float, lifespan:Float, speed:Float, color:Int)
	{
		super(startX - radius, startY - radius);
		
		velocity.x = Math.cos(movementAngle) * speed;
		velocity.y = Math.sin(movementAngle) * speed;
		drag.x = drag.y = 0;
		
		this.side = side;
		
		this.lifespan = lifespan;
		
		makeGraphic(Math.floor(radius * 2), Math.floor(radius * 2), color);
	}
	
	public function expired()
	{
		return lifespan <= 0.0;
	}
	public function damage(target:Damageable) {
		if (side != target.side) {
			//trace("giving " + dmg + " damage");
			target.takeDamage(dmg);
			//this.kill();
			this.destroy();
		}
	}
	public override function update()
	{
		super.update();
		lifespan -= FlxG.elapsed;
	}
}