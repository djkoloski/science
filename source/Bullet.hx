package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.util.FlxColor;

import collision.Collision;
import collision.ICollidable;
import collision.IDamageable;
import collision.IHurtable;
import collision.DamagerSprite;

class Bullet extends FlxGroup implements IHurtable
{
	public var state:PlayState;
	public var lifespan:Float;
	public var damageMask:Int;
	public var damageAmount:Int;
	public var sprite:DamagerSprite;
	
	public var x(get, set):Float;
	public var y(get, set):Float;
	
	public function new(state:PlayState, startX:Float, startY:Float, movementAngle:Float, damageMask:Int, radius:Float, lifespan:Float, speed:Float, color:Int)
	{
		super();
		
		this.state = state;
		
		this.lifespan = lifespan;
		this.damageMask = damageMask;
		this.damageAmount = 5;
		
		this.sprite = new DamagerSprite(startX, startY);
		this.sprite.setProxy(this);
		this.sprite.makeGraphic(Math.floor(radius * 2), Math.floor(radius * 2), color);
		this.sprite.centerOrigin();
		this.sprite.velocity.x = Math.cos(movementAngle) * speed;
		this.sprite.velocity.y = Math.sin(movementAngle) * speed;
		this.sprite.drag.x = this.sprite.drag.y = 0;
		
		add(this.sprite);
		this.state.collision.add(this.sprite);
	}
	
	public override function update()
	{
		super.update();
		
		lifespan -= FlxG.elapsed;
		
		if (lifespan <= 0)
		{
			destroy();
		}
	}
	
	public function isSolid():Bool
	{
		return false;
	}
	
	public function getObject():Dynamic
	{
		return this;
	}
	
	public function onCollision(other:ICollidable):Void
	{
		Collision.switchFlags(
			this,
			other,
			this.destroy,
			null,
			Collision.performDamage.bind(this, cast other)
		);
	}
	
	public function getDamagerMask():Int
	{
		return damageMask;
	}
	
	public function dealDamage():Int
	{
		destroy();
		return damageAmount;
	}
	
	public function get_x():Float
	{
		return sprite.x;
	}
	
	public function set_x(value:Float):Float
	{
		return sprite.x = value;
	}
	
	public function get_y():Float
	{
		return sprite.y;
	}
	
	public function set_y(value:Float):Float
	{
		return sprite.y = value;
	}
}