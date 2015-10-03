package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.util.FlxColor;
import flixel.group.FlxGroup;

import Assert;

/**
 * A FlxState which can be used for the game's menu.
 */
class MenuState extends FlxState
{
	private var hud:FlxGroup;
	private var heart:FlxSprite;
	private var barFrame:FlxSprite;
	private var barBackground:FlxSprite;
	private var barForeground:FlxSprite;
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		var a = Std.random(2);
		var b = 1 - a;
		Assert.info(a == 0 && b == 0, "This should happen");
		super.create();
	}
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		super.destroy();
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void
	{
		super.update();
	}	
}