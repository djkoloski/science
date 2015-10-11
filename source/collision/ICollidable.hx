package collision;

interface ICollidable
{
	public function getCollisionFlags():Int;
	public function onCollision(other:ICollidable):Void;
}