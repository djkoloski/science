package collision;
import flixel.util.FlxPoint;

@:generic
class DamageableProxy<T:IProxy> extends T implements IDamageable
{
	public function getDamageableMask():Int
	{
		return getProxy().getDamageableMask();
	}
	public function stun(velocity:FlxPoint): Void {
		getProxy().stun(velocity);
	}
	public function receiveDamage(damage:Int,source:Int):Void
	{
		getProxy().receiveDamage(damage,source);
	}
}