package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;

class Teleporter extends FlxSprite
{
	public static var TARGET_PREFIX = "assets/tiled/";
	public static var TARGET_SUFFIX = ".tmx";
	
	public var state:PlayState;
	public var target:String;
	
	public function new(state:PlayState, x:Float, y:Float, width:Float, height:Float, target:String) 
	{
		super(x, y);
		makeGraphic(Math.round(width), Math.round(height), 0x7fff00ff);
#if debug
		visible = true;
#else
		visible = false;
#end
		updateHitbox();
		
		this.state = state;
		this.target = target;
	}
	
	public override function update()
	{
		super.update();
		
		if (FlxG.overlap(state.player, this))
		{
			state.changeLevel(TARGET_PREFIX + target + TARGET_SUFFIX);
		}
	}
}