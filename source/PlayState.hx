package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxObject;
import flixel.text.FlxText;
import flixel.group.FlxGroup;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.tile.FlxTilemap;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState
{
	public var level:LevelMap;
	
	public var coins:FlxGroup;
	public var player:FlxSprite;
	public var floor:FlxObject;
	public var exit:FlxSprite;
	
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		super.create();
		
		bgColor = 0xffaaaaaa;
		
		level = new LevelMap("assets/tiled/leveltest.tmx");
		
		add(level.backgroundTiles);
		add(level.foregroundTiles);
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
		
		level.collideWithLevel(player);
	}	
}