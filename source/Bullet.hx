package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.util.FlxColor;

class Bullet extends FlxGroup implements Damager
{
	public var state:PlayState;
	public var lifespan:Float;
	public var side:Side;
	public var damageAmount:Int;
	public var sprite:FlxSprite;
	
	public function new(state:PlayState, startX:Float, startY:Float, movementAngle:Float, side:Side, radius:Float, lifespan:Float, speed:Float, color:Int)
	{
		super();
		
		this.state = state;
		
		this.lifespan = lifespan;
		this.side = side;
		this.damageAmount = 5;
		
		this.sprite = new FlxSprite(startX, startY);
		this.sprite.makeGraphic(Math.floor(radius * 2), Math.floor(radius * 2), color);
		this.sprite.centerOrigin();
		this.sprite.velocity.x = Math.cos(movementAngle) * speed;
		this.sprite.velocity.y = Math.sin(movementAngle) * speed;
		this.sprite.drag.x = this.sprite.drag.y = 0;
		
		add(this.sprite);
		
		this.state.addDamager(this, this.sprite);
	}
	
	public function getDamageSide():Side
	{
		return side;
	}
	
	public function dealDamage():Int
	{
		destroy();
		return damageAmount;
	}
	
	public override function update()
	{
		super.update();
		
		lifespan -= FlxG.elapsed;
		
		if (lifespan <= 0 || state.level.collideWith(sprite))
		{
			destroy();
		}
	}
}