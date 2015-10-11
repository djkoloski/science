package collision;

import flixel.FlxObject;

@:generic
class ColliderProxy<T:(FlxObject, IProxy)> extends T implements ICollidable
{
	private inline function getColliderProxy():ICollidable
	{
		Assert.info(getProxy() != null, "Collider proxy not set");
		return cast getProxy();
	}
	
	public function isSolid():Bool
	{
		return getColliderProxy().isSolid();
	}
	
	public function getObject():Dynamic
	{
		return getColliderProxy();
	}
	
	public function onCollision(other:ICollidable):Void
	{
		getColliderProxy().onCollision(other);
	}
}