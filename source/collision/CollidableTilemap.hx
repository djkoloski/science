package collision;

import flixel.FlxObject;
import flixel.tile.FlxTilemap;

import collision.ICustomCollidable;

class CollidableTilemap extends FlxTilemap implements ICustomCollidable
{
	public function isSolid():Bool
	{
		return true;
	}
	
	public function getObject():Dynamic
	{
		return this;
	}
	
	public function onCollision(other:ICollidable):Void
	{}
	
	public function collisionOverlaps(other:FlxObject):Bool
	{
		return overlaps(other);
	}
}