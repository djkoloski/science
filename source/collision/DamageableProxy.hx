package collision;

@:generic
class DamageableProxy<T:IProxy> extends T implements IDamageable
{
	public function getDamageableMask():Int
	{
		return getProxy().getDamageableMask();
	}
	
	public function receiveDamage(damage:Int,source:Int):Void
	{
		getProxy().receiveDamage(damage,source);
	}
}