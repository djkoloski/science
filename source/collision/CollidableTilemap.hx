package collision;

import flixel.FlxObject;
import flixel.tile.FlxTilemap;

import collision.ICustomCollidable;
import collision.CollisionFlags;

class CollidableTilemap extends FlxTilemap implements ICustomCollidable
{
	public function getCollisionFlags():Int
	{
		return CollisionFlags.SOLID;
	}
	
	public function onCollision(other:ICollidable):Void
	{}
	
	public function collisionOverlaps(other:FlxObject):Bool
	{
		return overlaps(other);
	}
}