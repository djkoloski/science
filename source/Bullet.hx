package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;

class Bullet extends FlxSprite
{
	public var lifespan:Float;
	
	public function new(startX:Float, startY:Float, movementAngle:Float, radius:Float, lifespan:Float, speed:Float, color:Int)
	{
		super(startX - radius, startY - radius);
		
		trace("successful fire");
		velocity.x = Math.cos(movementAngle) * speed;
		velocity.y = Math.sin(movementAngle) * speed;
		drag.x = drag.y = 0;
		
		this.lifespan = lifespan;
		
		makeGraphic(Math.floor(radius * 2), Math.floor(radius * 2), color);
	}
	
	public function expired()
	{
		return lifespan <= 0.0;
	}
	
	public override function update()
	{
		super.update();
		lifespan -= FlxG.elapsed;
	}
}