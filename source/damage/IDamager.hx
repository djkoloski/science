package damage;

interface IDamager
{
	public function getDamageSide():Side;
	public function provideDamage():Int;
}