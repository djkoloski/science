package;
import flixel.FlxG;
import flixel.group.FlxGroup;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.util.FlxColor;
import flixel.util.FlxAngle;

import collision.ICollidable;
import collision.CollidableSprite;
import collision.Collision;
import collision.CollisionFlags;

class Interactive extends FlxGroup implements ICollidable
{
	public var state:PlayState;
	
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
	
	public function onInteraction():Void
	{}
	
	public function getCollisionFlags():Int
	{
		return CollisionFlags.NONE;
	}
	
	public function onCollision(other:ICollidable):Void
	{
		if (Collision.resolve(other) == state.player && FlxG.keys.justPressed.SPACE)
		{
			onInteraction();
		}
	}
}
