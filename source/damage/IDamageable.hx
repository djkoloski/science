package damage;

interface IDamageable
{
	public function checkReceivesDamage(side:Side):Bool;
	public function receiveDamage(amount:Int, side:Side):Void;
}