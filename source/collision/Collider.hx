package collision;

class Collider<T:(FlxObject)> extends T implements ICollidable
{
	public state:PlayState;
	public function new(state:PlayState, onCollision:ICollidable->Void, collisionTag:ECollisionTag, args:Array<Dynamic>)
	{
		Reflect.callMethod(this, super, args);
		this.state = state;
		this.onCollision = onCollision;
		this.collisionTag = collisionTag;
		
		this.state.addCollider(this);
	}
	
	public override function destroy():Void
	{
		state.removeCollider(this);
	}
}