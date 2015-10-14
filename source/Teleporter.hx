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
	public static var TARGET_PREFIX = "assets/tiled/";
	public static var TARGET_SUFFIX = ".tmx";
	
	public var state:PlayState;
	public var level:String;
	public var spawn:String;
	
	public var sprite:CollidableSprite;
	
	public function new(state:PlayState, x:Float, y:Float, width:Float, height:Float, level:String, spawn:String) 
	{
		super();
		
		this.state = state;
		this.level = level;
		this.spawn = spawn;
		
		this.sprite = new CollidableSprite(x, y);
		this.sprite.setProxy(this);
		this.sprite.makeGraphic(Math.round(width), Math.round(height), 0x7fff00ff);
#if debug
		this.sprite.visible = true;
#else
		this.sprite.visible = false;
#end
		add(this.sprite);
		this.state.collision.add(this.sprite);
	}
	
	public function getCollisionFlags():Int
	{
		return CollisionFlags.NONE;
	}
	
	public function onCollision(other:ICollidable):Void
	{
		if (Collision.resolve(other) == state.player && state.necessaryMobs.length == 0)
		{
			state.changeLevel(TARGET_PREFIX + level + TARGET_SUFFIX, spawn);
		}
	}
}