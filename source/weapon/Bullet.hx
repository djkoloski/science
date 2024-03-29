package weapon;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.util.FlxColor;

import collision.Collision;
import collision.ICollidable;
import collision.IDamageable;
import collision.IHurtable;
import collision.DamagerSprite;
import collision.CollisionFlags;

class Bullet extends FlxGroup implements IHurtable
{
	public var state:PlayState;
	public var lifespan:Float;
	public var damageMask:Int;
	public var damageAmount:Int;
	public var sprite:DamagerSprite;
	
	public var x(get, set):Float;
	public var y(get, set):Float;
	
	public var effect: String;
	
	public function new(state:PlayState, startX:Float, startY:Float, velocityX:Float, velocityY:Float, damageMask:Int, radius:Float, lifespan:Float, amount:Int, color:Int,effect:String ="")
	{
		super();
		
		this.effect = effect;
		this.state = state;
		
		this.lifespan = lifespan;
		this.damageMask = damageMask;
		this.damageAmount = amount;
		
		this.sprite = new DamagerSprite(startX, startY);
		this.sprite.setProxy(this);
		this.sprite.makeGraphic(Math.floor(radius * 2), Math.floor(radius * 2), color);
		this.sprite.centerOrigin();
		this.sprite.velocity.x = velocityX;
		this.sprite.velocity.y = velocityY;
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
	
	public function getCollisionFlags():Int
	{
		return CollisionFlags.NONE;
	}
	
	public function onCollision(other:ICollidable):Void
	{
		var bullet = this;
		Collision.switchFlags(
			this,
			other,
			function()
			{
				if (!Std.is(other, IDamageable) || (cast(other, IDamageable).getDamageableMask() & bullet.getDamagerMask()) != 0)
				{
					bullet.destroy();
				}
			},
			null,
			Collision.performDamage.bind(this, cast other)
		);
	}
	
	public function getDamagerMask():Int
	{
		return damageMask;
	}
	
	public function dealDamage(target:IDamageable):Int
	{
		if (effect == "stun") {
			//trace(sprite.velocity);
			target.stun(sprite.velocity);
			state.add(new Shockwave(x,y));
		}
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