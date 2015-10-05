package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
<<<<<<< HEAD
import flixel.util.FlxColor;
import flixel.group.FlxGroup;
=======
import flixel.util.FlxDestroyUtil;

>>>>>>> origin/Sam's_Branch

import PlayState;

/**
 * A FlxState which can be used for the game's menu.
 */
class MenuState extends FlxState
{
<<<<<<< HEAD
	private var hud:FlxGroup;
	private var heart:FlxSprite;
	private var barFrame:FlxSprite;
	private var barBackground:FlxSprite;
	private var barForeground:FlxSprite;
=======
	private var _btnPlay:FlxButton;
	
>>>>>>> origin/Sam's_Branch
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
<<<<<<< HEAD
		super.create();
		
		FlxG.switchState(new PlayState());
=======

		_btnPlay = new FlxButton(50, 50, "Play", clickPlay);
		add(_btnPlay);
		 
		super.create();
		
>>>>>>> origin/Sam's_Branch
	}
	 
	//Change to the play state.
	private function clickPlay():Void
	{
     FlxG.switchState(new PlayState());
	 
	 }
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		_btnPlay = FlxDestroyUtil.destroy(_btnPlay);
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