package weapon;

import collision.IDamageable;
import flixel.FlxG;
import flixel.group.FlxGroup;
import flixel.FlxSprite;
import flixel.util.FlxPoint;
import flixel.util.FlxColor;
import flixel.FlxObject;

import collision.Collision;
import collision.IHurtable;
import collision.DamagerSprite;
import collision.ICollidable;
import collision.CollisionFlags;

using flixel.util.FlxSpriteUtil;

class LaserBeam extends FlxGroup implements IHurtable
{
	public var state:PlayState;
	
	public var damagerMask:Int;
	public var dps:Float;
	public var startPoint:FlxPoint;
	public var endPoint:FlxPoint;
	
	public var sprite:DamagerSprite;
	
	public function new(state:PlayState, damagerMask:Int, dps:Float)
	{
		super();
		
		this.state = state;
		
		this.sprite = new DamagerSprite();
		this.sprite.setProxy(this);
		
		this.damagerMask = damagerMask;
		this.dps = dps;
		this.startPoint = new FlxPoint();
		this.endPoint = new FlxPoint();
		
		add(this.sprite);
		this.state.collision.add(this.sprite);
	}
	
	public function setEndpoints(startX:Float, startY:Float, endX:Float, endY:Float):Void
	{
		this.startPoint.x = startX;
		this.startPoint.y = startY;
		this.endPoint.x = endX;
		this.endPoint.y = endY;
		
		var dp = new FlxPoint(endX - startX, endY - startY);
		
		sprite.makeGraphic(
			5 + Math.round(Math.abs(dp.x)),
			5 + Math.round(Math.abs(dp.y)),
			FlxColor.TRANSPARENT,
			true
		);
		
		var offset = new FlxPoint(Math.min(dp.x, 0), Math.min(dp.y, 0));
		var position = new FlxPoint(startX + offset.x, startY + offset.y);
		var drawStart = new FlxPoint(-offset.x, -offset.y);
		var drawEnd = new FlxPoint(Math.abs(dp.x) - drawStart.x, Math.abs(dp.y) - drawStart.y);
		
		var lineStyle:LineStyle = {
			thickness:5,
			color: 0xFFFF0000
		};
		
		sprite.drawLine(drawStart.x, drawStart.y, drawEnd.x, drawEnd.y, lineStyle);
		sprite.x = position.x;
		sprite.y = position.y;
		sprite.updateSpriteGraphic();
	}
	
	public function getCollisionFlags():Int
	{
		return CollisionFlags.NONE;
	}
	
	public function onCollision(other:ICollidable):Void
	{
		var laserBeam:LaserBeam = this;
		Collision.switchFlags(
			this,
			other,
			null,
			null,
			function()
			{
				var object:FlxObject = cast other;
				
				if (
					MathHelper.pointToLineSegmentDistance(
						laserBeam.startPoint,
						laserBeam.endPoint,
						new FlxPoint(
							object.x + object.width / 2,
							object.y + object.height / 2
						)
					) < (object.width + object.height) / 2
				)
				{
					Collision.performDamage(this, cast other);
				}
			}
		);
	}
	
	public function getDamagerMask():Int
	{
		return damagerMask;
	}
	
	public function dealDamage(target:IDamageable):Int
	{
		return Math.ceil(dps * FlxG.elapsed);
	}
}