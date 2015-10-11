package;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.group.FlxGroup;

import collision.ICollidable;
import collision.CollidableSprite;

class Collectible extends FlxGroup implements ICollidable
{
	public var state:PlayState;
	public var type:String;
	
	public var sprite:CollidableSprite;
	
	public function new(state:PlayState, startX:Float, startY:Float, type:String = "health")
	{
		super();
		
		this.state = state;
		this.type = type;
		
		this.sprite = new CollidableSprite(startX, startY);
		this.sprite.setProxy(this);
		if (this.type == "health")
		{
			this.sprite.makeGraphic(20, 20, FlxColor.PINK);
		}
		else
		{
			this.sprite.makeGraphic(20, 20, FlxColor.KHAKI);
		}
		
		add(this.sprite);
		this.state.collision.add(this.sprite);
	}
	
	public function isSolid():Bool
	{
		return false;
	}
	
	public function getObject():Dynamic
	{
		return this;
	}
	
	public function onCollision(other:ICollidable):Void
	{
		if (other.getObject() == state.player)
		{
			state.player.stats.addHearts(1);
			destroy();
		}
	}
}