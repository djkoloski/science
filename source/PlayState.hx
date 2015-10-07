package;

import flash.system.System;
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
	public var bullets:Array<Bullet>;
	
	
	private var hud:FlxGroup;
	
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		super.create();
		
		hud = new HUD();
		
		bgColor = 0xffaaaaaa;
		
		level = new LevelMap("assets/tiled/leveltest.tmx",this);
		player = new Player(this, level.startX, level.startY);
		
		
		FlxG.camera.follow(player, FlxCamera.STYLE_TOPDOWN, new FlxPoint(0, 0), 1.0);
		FlxG.camera.setBounds(0, 0, level.fullWidth, level.fullHeight, true);
		
		bullets = new Array<Bullet>();
		
		add(level.backgroundGroup);
		add(player);
		add(level.foregroundGroup);

		add(level.enemyGroup);
		
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
		super.update();
		
		if (FlxG.keys.justPressed.ESCAPE)
		{
			System.exit(0);
		}
		
		updateBullets();
		
		level.collideWith(player);
	}
	
	public function addBullet(bullet:Bullet):Void
	{
		bullets.push(bullet);
		add(bullet);
	}
	
	public function removeBullet(bullet:Bullet):Void
	{
		remove(bullet);
		bullets.splice(bullets.indexOf(bullet), 1);
	}
	
	public function updateBullets():Void
	{
		var i:Int = 0;
		while (i < bullets.length)
		{
			if (bullets[i].expired() || level.collideWith(bullets[i]))
			{
				removeBullet(bullets[i]);
				--i;
			}
			++i;
		}
	}
}