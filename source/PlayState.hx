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
import flixel.util.FlxAngle;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState
{
	public var level:LevelMap;
	public var player:Player;
	public var weapon: Weapon;
	public var weapons =  new FlxGroup(100);
	private var bulletDelay:Float = 0;
	
	private var hud:FlxGroup;
	
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		super.create();
		
		hud = new HUD();
		
		bgColor = 0xffaaaaaa;
		
		level = new LevelMap("assets/tiled/leveltest.tmx");
		player = new Player(level.startX, level.startY);
		
		FlxG.camera.follow(player, FlxCamera.STYLE_TOPDOWN, new FlxPoint(0, 0), 1.0);
		FlxG.camera.setBounds(0, 0, level.fullWidth, level.fullHeight, true);
		
		add(level.backgroundGroup);
		add(player);
		add(level.foregroundGroup);
		
		add(hud);
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
		var bAngle: Float = 0;
		bulletDelay--;
		var primary:Bool = FlxG.keys.justPressed.SPACE;
		var secondary:Bool = FlxG.keys.justPressed.SHIFT;
		
		if (primary)
		{
			weapon = new Weapon(player.x, player.y, player.movementAngle, 2);
			add(weapon);
			weapons.add(weapon);
		}
		if (secondary)
		{
			weapon = new Weapon(player.x, player.y, player.movementAngle, 1);
			add(weapon);
			weapons.add(weapon);
		}
		
		super.update();
		
		level.collideWith(player);
	}	
}