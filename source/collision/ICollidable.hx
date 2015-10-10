package collision;

interface ICollidable
{
	public var onCollision:ICollidable->Void;
	public var collisionTag:ECollisionTag;
}