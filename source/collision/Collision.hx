package collision;

import flixel.FlxObject;

class Collision
{
	public static function resolve(collidable:ICollidable):ICollidable
	{
		if (Std.is(collidable, IProxy))
		{
			var proxy:IProxy = cast collidable;
			return proxy.getProxy();
		}
		return collidable;
	}
	
	public static function separate(first:flixel.FlxObject, second:FlxObject)
	{
		FlxObject.separate(first, second);
	}
	
	public static function performDamage(damager:IDamager, damageable:IDamageable):Void
	{
		//if ((damager.getDamagerMask() & damageable.getDamageableMask()) != 0)
		if(damager.getDamagerMask() != damageable.getDamageableMask())
		{
			damageable.receiveDamage(damager.dealDamage(),damager.getDamagerMask());
		}
	}
	
	public static function switchFlags(first:ICollidable, second:ICollidable, ?onSolid:Void->Void, ?onDamager:Void->Void, ?onDamageable:Void->Void):Void
	{
		if ((second.getCollisionFlags() & CollisionFlags.SOLID) != 0 && onSolid != null)
		{
			onSolid();
		}
		if (Std.is(second, IDamager) && onDamager != null)
		{
			onDamager();
		}
		if (Std.is(second, IDamageable) && onDamageable != null)
		{
			onDamageable();
		}
	}
}