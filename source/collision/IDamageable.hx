package collision;

interface IDamageable
{
	public function getDamageableMask():Int;
	public function receiveDamage(damage:Int):Void;
}