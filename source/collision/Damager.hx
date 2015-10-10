package collision;

class Damager<T:(FlxObject)> extends Collider<T>
{
	public function new(state:PlayState, parent:DamageProvider, args:Array<Dynamic>)
	{
		super(state, this.onDamagerCollision.bind(this), CollisionTag_Damager, args);
	}
	
	private function onDamagerCollision(Collidable other):Void
	{
		if (other.collisionTag == CollisionTag_Damageable)
		{
			
	}
}