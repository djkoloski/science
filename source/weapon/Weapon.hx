package weapon;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.util.FlxColor;
import flixel.FlxState;

class Weapon extends FlxGroup
{
	public var state:PlayState;
	public var damageMask:Int;
	
	public var posX:Float;
	public var posY:Float;
	public var dirX:Float;
	public var dirY:Float;
	
	public function new(state:PlayState, damageMask:Int)
	{
		super();
		
		this.state = state;
		this.damageMask = damageMask;
		
		this.posX = 0;
		this.posY = 0;
		this.dirX = 0;
		this.dirY = 0;
	}
	
	public function setTransform(posX:Float, posY:Float, dirX:Float, dirY:Float, radius:Float):Void
	{
		if (dirX != 0 || dirY != 0)
		{
			this.dirX = dirX;
			this.dirY = dirY;
		}
		
		this.posX = posX + this.dirX * radius;
		this.posY = posY + this.dirY * radius;
	}
	
	public function fire()
	{
	}
	
	public function getCooldown():Float
	{
		return 0;
	}
}