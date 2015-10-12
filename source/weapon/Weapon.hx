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
	
	public function new(state:PlayState, damageMask:Int)
	{
		super();
		
		this.state = state;
		this.damageMask = damageMask;
	}
	
	public function fire(startX:Float, startY:Float, angle:Float)
	{
	}
}