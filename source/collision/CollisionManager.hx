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
				
				var firstCustom = Std.is(first, ICustomCollidable);
				var secondCustom = Std.is(second, ICustomCollidable);
				
				var firstNoCustom = (first.getCollisionFlags() & CollisionFlags.NOCUSTOM) != 0;
				var secondNoCustom = (second.getCollisionFlags() & CollisionFlags.NOCUSTOM) != 0;
				
				if (colliding && firstCustom)
				{
					if (secondNoCustom)
					{
						colliding = false;
					}
					else
					{
						var customCollidable:ICustomCollidable = cast first;
						colliding = customCollidable.collisionOverlaps(cast second);
					}
				}
				if (colliding && Std.is(second, ICustomCollidable))
				{
					if (firstNoCustom)
					{
						colliding = false;
					}
					else
					{
						var customCollidable:ICustomCollidable = cast second;
						colliding = customCollidable.collisionOverlaps(cast first);
					}
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