package collision;

interface ICollidable
{
	public function isSolid():Bool;
	public function getObject():Dynamic;
	public function onCollision(other:ICollidable):Void;
}