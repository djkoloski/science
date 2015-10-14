package collision;

import flixel.FlxObject;

interface ICustomCollidable extends ICollidable
{
	public function collisionOverlaps(other:FlxObject):Bool;
}