package collision;

interface IDamager
{
	public function getDamagerMask():Int;
	public function dealDamage(damageable:IDamageable):Int;
}