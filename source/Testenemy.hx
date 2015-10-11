package;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxPoint;

import collision.DamageMask;

class Testenemy extends Mob
{
	public function new(state:PlayState, x:Float, y:Float, spritePath:String = null) 
	{
		super(state, x, y, DamageMask.ENEMY, spritePath);
	}
	
	public override function update():Void
	{
		target.x = state.player.x;
		target.y = state.player.y;
		
		super.update();
		
		attack();
	}
}