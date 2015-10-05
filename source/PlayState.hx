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
import flixel.FlxCamera;
import flixel.util.FlxPoint;
import flixel.group.FlxGroup;
import flixel.util.FlxColor;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState
{
	public var level:LevelMap;
	public var player:Player;
	
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
		hud = new FlxGroup();
		
		heart = new FlxSprite(10, 5);
		heart.makeGraphic(1, 10, 0xffff0000);
		heart.scale.x = 25;
		heart.scrollFactor.x = heart.scrollFactor.y = 0;
		hud.add(heart);
		
		barFrame = new FlxSprite(5, 25);
		barFrame.makeGraphic(200, 50);
		barFrame.scrollFactor.x = barFrame.scrollFactor.y = 0;
		hud.add(barFrame);
		
		barBackground = new FlxSprite(10, 30);
		barBackground.makeGraphic(190, 40, 0xff000000);
		barBackground.scrollFactor.x = barBackground.scrollFactor.y = 0;
		hud.add(barBackground);
		
		barForeground = new FlxSprite(10, 30);
		barForeground.makeGraphic(1, 40, 0xffff0000);
		barForeground.scrollFactor.x = barForeground.scrollFactor.y = 0;
		barForeground.origin.x = barForeground.origin.y = 0;
		barForeground.scale.x = 190;
		hud.add(barForeground);
		
		add(hud);
		
		super.create();
		
		bgColor = 0xffaaaaaa;
		
		level = new LevelMap("assets/tiled/leveltest.tmx");
		player = new Player(this, level.startX, level.startY);
		
		FlxG.camera.follow(player, FlxCamera.STYLE_TOPDOWN, new FlxPoint(0, 0), 1.0);
		FlxG.camera.setBounds(0, 0, level.fullWidth, level.fullHeight, true);
		
		add(level.backgroundGroup);
		add(player);
		add(level.foregroundGroup);
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
		
		barForeground.scale.x = 100;
		level.collideWith(player);
	}	
}