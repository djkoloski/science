package collision;

@:generic
class DamagerProxy<T:IProxy> extends T implements IDamager
{
	public function getDamagerMask():Int
	{
		return getProxy().getDamagerMask();
	}
	
	public function dealDamage():Int
	{
		return getProxy().dealDamage();
	}
}