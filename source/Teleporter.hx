package;

import flixel.FlxG;
import flixel.group.FlxGroup;
import flixel.FlxObject;
import flixel.FlxSprite;

import collision.Collision;
import collision.CollisionFlags;
import collision.ICollidable;
import collision.CollidableSprite;

class Teleporter extends FlxGroup implements ICollidable
{
	public var state:PlayState;
	public var level:String;
	public var spawn:String;
	public var locked:Bool;
	
	public var sprite:CollidableSprite;
	
	public function new(state:PlayState, x:Float, y:Float, width:Float, height:Float, level:String, spawn:String, locked:Bool) 
	{
		super();
		
		this.state = state;
		this.level = level;
		this.spawn = spawn;
		this.locked = locked;
		
		this.sprite = new CollidableSprite(x, y);
		this.sprite.setProxy(this);
		this.sprite.loadGraphic(AssetPaths.teleporter__png, true, 64, 64);
		this.sprite.animation.add("active", [0], 1, false);
		this.sprite.animation.add("inactive", [1], 1, false);
		this.sprite.immovable = true;
		
		add(this.sprite);
		this.state.collision.add(this.sprite);
	}
	
	public function getCollisionFlags():Int
	{
		return (locked ? CollisionFlags.SOLID : CollisionFlags.NONE);
	}
	
	public function onCollision(other:ICollidable):Void
	{
		if (Collision.resolve(other) == state.player && !locked)
		{
			state.changeLevel(level, spawn);
		}
	}
	
	public override function update()
	{
		super.update();
		
		if (locked)
		{
			locked = (state.necessaryMobs.length != 0);
			this.sprite.animation.play("inactive");
		}
		else
		{
			this.sprite.animation.play("active");
		}
	}
}