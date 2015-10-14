package;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.group.FlxGroup;

import collision.ICollidable;
import collision.CollidableSprite;
import collision.Collision;
import collision.CollisionFlags;

class Collectible extends FlxGroup implements ICollidable
{
	public var state:PlayState;
	public var type:String;
	
	public var sprite:CollidableSprite;
	
	public function new(state:PlayState, startX:Float, startY:Float, spritePath:String)
	{
		super();
		
		this.state = state;
		
		this.sprite = new CollidableSprite(startX, startY);
		this.sprite.setProxy(this);
		this.sprite.loadGraphic(spritePath);
		
		add(this.sprite);
		this.state.collision.add(this.sprite);
	}
	
	public function getCollisionFlags():Int
	{
		return CollisionFlags.NONE;
	}
	
	public function onCollision(other:ICollidable):Void
	{
		if (Collision.resolve(other) == state.player)
		{
			onCollect();
			//state.player.stats.addHearts(1);
			destroy();
		}
	}
	
	public function onCollect():Void
	{}
}