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

import collision.Collidable;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState
{
	public var level:LevelMap;
	public var dialogue:DialogueDictionary;
	public var dialogueManager:DialogueManager;
	
	public var player:Player;
	public var interactanble: InteractableDialogueBox;
	
	public var teleporters:Array<Teleporter>;
	public var hud:PlayerHUD;
	
	public var colliders:FlxGroup;
	
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		super.create();
		
		bgColor = 0xffaaaaaa;
		
		level = null;
		dialogue = new DialogueDictionary();
		dialogueManager = new DialogueManager(this);
		
		player = new Player(this);
		// TODO: Interactables
		
		teleporters = new Array<Teleporter>();
		hud = new PlayerHUD(player);
		
		FlxG.camera.follow(player, FlxCamera.STYLE_TOPDOWN, new FlxPoint(0, 0), 1.0);
		
		changeLevel("assets/tiled/Level1.tmx");
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
		
		FlxG.overlap(
			colliders,
			colliders,
			function(first:Collidable, second:Collidable) {
				first.onCollision(second);
				second.onCollision(first);
			}
		);
		
		/*
		FlxG.overlap(player, collectibles, function(player:Player, collectible:Collectible) {
			if (collectible.getType() == "health") {
				player.stats.addHearts(cast(collectible, HeartCollectible).getHeal());
				collectible.destroy();
			}
		});
		*/
		
		if (FlxG.keys.justPressed.ESCAPE)
		{
			System.exit(0);
		}
		
		if (FlxG.keys.justPressed.R)
		{
			trace("opening");
			dialogueManager.addDialogue("DIALOGUE_OTHER");
			dialogueManager.openDialogue();
		}
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
		clear();
		
		level = null;
		teleporters = new Array<Teleporter>();
	}
	
	public function loadLevel(path:String):Void
	{
		level = new LevelMap(this, path);
		
		FlxG.camera.setBounds(0, 0, level.fullWidth, level.fullHeight, true);
		
		add(level.backgroundGroup);
		
		for (teleporter in teleporters)
		{
			add(teleporter);
		}
		
		add(player);
		add(level.foregroundGroup);
		add(level.enemyGroup);
		add(hud);
		add(dialogueManager);
	}
	
	public function addCollider(collidable:FlxObject):Void
	{
		colliders.add(collidable);
	}
	
	public function removeCollider(collidable:FlxObject):Void
	{
		colliders.remove(collidable);
	}
}