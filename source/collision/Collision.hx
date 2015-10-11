package collision;

import flixel.FlxObject;

class Collision
{
	public static function separate(first:flixel.FlxObject, second:FlxObject)
	{
		FlxObject.separate(first, second);
	}
	
	public static function performDamage(damager:IDamager, damageable:IDamageable):Void
	{
		if ((damager.getDamagerMask() & damageable.getDamageableMask()) != 0)
		{
			damageable.receiveDamage(damager.dealDamage());
		}
	}
	
	public static function switchFlags(first:ICollidable, second:ICollidable, ?onSolid:Void->Void, ?onDamager:Void->Void, ?onDamageable:Void->Void):Void
	{
		if (second.isSolid() && onSolid != null)
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