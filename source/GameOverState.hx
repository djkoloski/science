package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxDestroyUtil;

/**
 * ...
 * @author ...
 */
class GameOverState extends FlxState
{
	
	private var ggButton:FlxButton;
	private var gg:FlxText;
	
	override public function create() 
	{
		super.create();
		ggButton = new FlxButton(FlxG.width / 2, FlxG.height / 2, "Main Menu", clickGG);
		gg = new FlxText(FlxG.width / 4, FlxG.height / 4, FlxG.width, "GG", true);
		gg.size = 400;
		add(ggButton);
		add(gg);
	}
	
	override public function destroy():Void
	{
		ggButton = FlxDestroyUtil.destroy(ggButton);
		gg = FlxDestroyUtil.destroy(gg);
		super.destroy();
	}
	
	override public function update():Void
	{
		super.update();
		
		if (FlxG.keys.justPressed.SPACE)
		{
			clickGG();
		}
	}
	
	private function clickGG():Void
	{
		FlxG.switchState(new MenuState());
	}
	
}