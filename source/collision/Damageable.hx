package collision;

import damage.IDamageable;

class DamageableForwarder<T> extends Collider<T> implements IDamageable
{
	public function new(state:PlayState, IDamageable
	
	public function checkReceivesDamage(side:Side):Bool
	{
		return true;
	}
	
	public function receiveDamage(amount:Int, side:Side):Void
	{}
}