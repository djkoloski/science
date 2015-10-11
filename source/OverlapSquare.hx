package;

import collision.ICollidable;
import collision.IDamageable;
import flixel.FlxObject;
import collision.Collision;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import collision.CollisionFlags;
/**
 * ...
 * @author ...
 */
class OverlapSquare extends FlxSprite implements ICollidable
{
	var inRange: Array<IDamageable>;
	public function new(X:Float=0, Y:Float=0, Width:Float=0, Height:Float=0) 
	{
		//super(X, Y, Width, Height);
		super(X, Y);
		makeGraphic(Math.floor(Width), Math.floor(Height), FlxColor.YELLOW);
		inRange = new Array<IDamageable>();
	}
	public function getCollisionFlags():Int {
		return CollisionFlags.NOCUSTOM;
	}
	public function onCollision(other:ICollidable):Void {
		Collision.switchFlags(
			this,
			other,
			null,
			//Collision.separate.bind(this.sprite, cast other),
			// Let damagers assign damage
			null,
			function() {
				this.inRange.push(cast Collision.resolve(other));
				if (this.inRange.length > 10) {
					trace(other);
				}
			}
		);
	}
	
	public function updateXY(x:Float, y:Float) {
		this.x = x - (width/2);
		this.y = y - (width/2);
	}
	
	public function clear() {
		inRange = new Array<IDamageable>();
	}
	
	public function getCollisionList():Array<IDamageable> {
		return inRange;
	}
	
}