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
import collision.IDamageable;

import collision.CollisionManager;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState
{
	public static var TILEMAP_PREFIX = "assets/tiled/";
	public static var TILEMAP_SUFFIX = ".tmx";
	
	public var collision:CollisionManager;
	public var group:FlxGroup;
	
	public var level:LevelMap;
	public var dialogue:DialogueDictionary;
	
	public var dialogueManager:DialogueManager;
	public var player:Player;
	
	public var enemies:Array<IDamageable>;
	
	public var aStarStart:FlxPoint;
	public var aStarEnd:FlxPoint;
	public var aStarTest:AStarTest;
	
	public var necessaryMobs:Array<Mob>;
	
	public var persistent:PersistentData;
	
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
		
		enemies = null;
		
		aStarStart = null;
		aStarEnd = null;
		aStarTest = null;
		
		necessaryMobs = null;
		
		persistent = null;
		
		#if debug
		changeLevel("Level1");
		#else
		changeLevel("FinalLevel1");
		#end
		
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
		
		if (FlxG.mouse.justPressed)
		{
			aStarStart = FlxG.mouse.getWorldPosition();
		}
		
		if (FlxG.mouse.justPressedRight)
		{
			aStarEnd = FlxG.mouse.getWorldPosition();
		}
		
		if (FlxG.keys.justPressed.P)
		{
			if (aStarTest != null)
			{
				remove(aStarTest);
				aStarTest.destroy();
			}
			aStarTest = new AStarTest();
			aStarTest.renderPath(aStarStart, aStarEnd, level.foreground.findPath(aStarStart, aStarEnd), Math.round(level.foreground.width), Math.round(level.foreground.height));
			add(aStarTest);
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
		
		if (path == "Death")
		{
			FlxG.switchState(new CutsceneState(new MenuState(), AssetPaths.cutscene_lose__png));
			return;
		}
		
		if (path == "Final")
		{
			FlxG.switchState(new CutsceneState(new MenuState(), AssetPaths.cutscene_outro__png));
			return;
		}
		
		path = TILEMAP_PREFIX + path + TILEMAP_SUFFIX;
		
		loadLevel(path);
		
		Assert.info(level.spawnPoints.exists(spawn), "Spawn point '" + spawn + "' not found in level '" + path + "'");
		player.x = level.spawnPoints[spawn].x;
		player.y = level.spawnPoints[spawn].y;
	}
	
	public function unloadLevel():Void
	{
		if (persistent == null)
		{
			persistent = new PersistentData();
		}
		persistent.save(this);
		
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
		
		player = null;
		dialogueManager = null;
		level = null;
	}
	
	public function loadLevel(path:String):Void
	{
		collision = new CollisionManager();
		group = new FlxGroup();
		super.add(group);
		
		enemies = new Array<IDamageable>();
		necessaryMobs = new Array<Mob>();
		
		dialogueManager = new DialogueManager(this);
		player = new Player(this);
		
		// TODO: keep player progression
		
		aStarStart = null;
		aStarEnd = null;
		aStarTest = null;
		
		level = new LevelMap(this, path);
		
		FlxG.camera.follow(player.sprite, FlxCamera.STYLE_TOPDOWN, new FlxPoint(0, 0), 1.0);
		FlxG.camera.setBounds(0, 0, level.fullWidth, level.fullHeight, true);
		
		add(level.background);
		
		add(level.foreground);
		collision.add(level.foreground);
		
		level.loadObjects();
		
		add(player);
		
		add(dialogueManager);
		
		add(new PlayerHUD(player));
		
		if (persistent != null)
		{
			persistent.restore(this);
		}
	}
}