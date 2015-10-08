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
import sys.io.File;
import openfl.Vector.VectorDataIterator;

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
	public var bullets:Array<Bullet>;
	
	public var teleporters:Array<Teleporter>;
	public var hud:PlayerHUD;
	
	public var damagers:FlxGroup;
	public var damagables:FlxGroup;
	public var collectibles:FlxGroup;
	
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		super.create();
		
		bgColor = 0xffaaaaaa;
		
		damagers = new FlxGroup();
		damagables = new FlxGroup();
		collectibles = new FlxGroup();
		
		level = null;
		dialogue = new DialogueDictionary();
		dialogueManager = new DialogueManager(this);
		
		player = new Player(this);
		damagables.add(player);
		
		bullets = new Array<Bullet>();
		teleporters = new Array<Teleporter>();
		hud = new PlayerHUD(player);
		
		FlxG.camera.follow(player, FlxCamera.STYLE_TOPDOWN, new FlxPoint(0, 0), 1.0);
		
		changeLevel("assets/tiled/leveltest.tmx");
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
		
		FlxG.overlap(damagers, damagables, function(damager:Damager, damagable:Damageable) {
			damager.damage(damagable);
		});
		
		FlxG.overlap(player, collectibles, function(player:Player, collectible:Collectible) {
			if (collectible.getType() == "health") {
				player.stats.addHearts(cast(collectible, HeartCollectible).getHeal());
				collectible.destroy();
			}
		});
		
		if (FlxG.keys.justPressed.ESCAPE)
		{
			System.exit(0);
		}
		
		updateBullets();
		
		level.collideWith(player);
		
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
		bullets = new Array<Bullet>();
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
	
	public function addBullet(bullet:Bullet):Void
	{
		bullets.push(bullet);
		damagers.add(bullet);
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
				bullets[i].destroy();
				removeBullet(bullets[i]);
				--i;
			}
			++i;
		}
	}
}