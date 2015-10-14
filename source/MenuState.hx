package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.util.FlxColor;
import flixel.util.FlxDestroyUtil;

import PlayState;

/**
 * A FlxState which can be used for the game's menu.
 */
class MenuState extends FlxState
{
	private var _btnPlay:FlxButton;
	
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		super.create();
		
		//FlxG.switchState(new PlayState());

		_btnPlay = new FlxButton(FlxG.width / 2, FlxG.height / 2, "Play", clickPlay);
		add(_btnPlay);
	}
	 
	//Change to the play state.
	private function clickPlay():Void
	{
		FlxG.switchState(new CutsceneState(new PlayState(), AssetPaths.cutscene_intro__png));
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
		
		if (FlxG.keys.justPressed.SPACE)
		{
			clickPlay();
		}
	}
}