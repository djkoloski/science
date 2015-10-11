package collision;

import flixel.FlxObject;
import flixel.group.FlxGroup;
import flixel.FlxG;

class CollisionManager
{
	public var colliders:FlxGroup;
	
	public function new()
	{
		colliders = new FlxGroup();
	}
	
	public function add<T:(FlxObject, ICollidable)>(collider:T):Void
	{
		colliders.add(collider);
	}
	
	public function remove<T:(FlxObject, ICollidable)>(collider:T):Void
	{
		colliders.remove(collider);
	}
	
	public function clear():Void
	{
		colliders.clear();
	}
	
	public function update():Void
	{
		FlxG.overlap(
			colliders,
			colliders,
			function(first:ICollidable, second:ICollidable)
			{
				var colliding = true;
				if (colliding && Std.is(first, ICustomCollidable))
				{
					var customCollidable:ICustomCollidable = cast first;
					colliding = customCollidable.collisionOverlaps(cast second);
				}
				if (colliding && Std.is(second, ICustomCollidable))
				{
					var customCollidable:ICustomCollidable = cast second;
					colliding = customCollidable.collisionOverlaps(cast first);
				}
				if (colliding)
				{
					first.onCollision(second);
					second.onCollision(first);
				}
			}
		);
	}
}