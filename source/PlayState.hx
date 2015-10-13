package;

import flash.system.System;
import flixel.FlxG;
import flixel.FlxBasic;
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
import sys.io.File;
import openfl.Vector.VectorDataIterator;
import flixel.system.FlxSound;

import collision.CollisionManager;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState
{
	public var collision:CollisionManager;
	public var group:FlxGroup;
	
	public var level:LevelMap;
	public var dialogue:DialogueDictionary;
	
	public var dialogueManager:DialogueManager;
	public var player:Player;
	
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		super.create();
		
		bgColor = 0xffaaaaaa;
		
		collision = null;
		group = null;
		
		level = null;
		dialogue = new DialogueDictionary();
		
		dialogueManager = null;
		player = null;
		
		changeLevel("assets/tiled/Level1.tmx");
		
		FlxG.sound.playMusic(AssetPaths.BackgroundMusic__wav, 1, true);
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
		
		collision.update();
		
		if (FlxG.keys.justPressed.ESCAPE)
		{
			System.exit(0);
		}
		
		if (FlxG.keys.justPressed.R)
		{
			dialogueManager.startDialogue("DIALOGUE_OTHER");
		}
	}
	
	public override function add(object:FlxBasic):FlxBasic
	{
		group.add(object);
		return object;
	}
	
	public override function remove(object:FlxBasic, splice:Bool = false):FlxBasic
	{
		return group.remove(object, splice);
	}
	
	public function changeLevel(path:String, ?spawn:String):Void
	{
		if (spawn == null)
		{
			spawn = "player_start";
		}
		
		if (level != null)
		{
			unloadLevel();
		}
		
		loadLevel(path);
		
		Assert.info(level.spawnPoints.exists(spawn), "Spawn point '" + spawn + "' not found in level '" + path + "'");
		player.x = level.spawnPoints[spawn].x;
		player.y = level.spawnPoints[spawn].y;
	}
	
	public function unloadLevel():Void
	{
		player.onLevelUnload();
		remove(player);
		dialogueManager.onLevelUnload();
		remove(dialogueManager);
		
		if (collision != null)
		{
			collision.clear();
			collision = null;
		}
		
		if (group != null)
		{
			group.destroy();
			group = null;
		}
		
		level = null;
	}
	
	public function loadLevel(path:String):Void
	{
		collision = new CollisionManager();
		group = new FlxGroup();
		super.add(group);
		
		if (player == null)
		{
			player = new Player(this);
		}
		player.onLevelLoad();
		
		if (dialogueManager == null)
		{
			dialogueManager = new DialogueManager(this);
		}
		dialogueManager.onLevelLoad();
		
		level = new LevelMap(this, path);
		
		FlxG.camera.follow(player.sprite, FlxCamera.STYLE_TOPDOWN, new FlxPoint(0, 0), 1.0);
		FlxG.camera.setBounds(0, 0, level.fullWidth, level.fullHeight, true);
		
		//add(level.background);
		
		level.loadObjects();
		
		add(player);
		
		add(level.foreground);
		collision.add(level.foreground);
		
		add(dialogueManager);
		
		add(new PlayerHUD(player));
	}
}