package;

import haxe.io.Path;
import flixel.FlxG;
import flixel.FlxBasic;
import flixel.FlxObject;
import flixel.util.FlxPoint;
import flixel.group.FlxGroup;
import flixel.tile.FlxTilemap;
import flixel.addons.editors.tiled.TiledMap;
import flixel.addons.editors.tiled.TiledObject;
import flixel.addons.editors.tiled.TiledObjectGroup;
import flixel.addons.editors.tiled.TiledTileSet;

import collision.CollidableTilemap;

class LevelMap extends TiledMap
{
	public var state:PlayState;
	
	public var foreground:CollidableTilemap;
	public var backgroundTiles:Array<FlxTilemap>;
	public var background:FlxGroup;
	
	public var spawnPoints:Map<String, FlxPoint>;
	
	public var startX:Float;
	public var startY:Float;
	
	public function new(playState:PlayState, filePath:Dynamic)
	{
		super(filePath);
		
		state = playState;
		
		foreground = null;
		backgroundTiles = new Array<FlxTilemap>();
		background = new FlxGroup();
		
		spawnPoints = new Map<String, FlxPoint>();
		
		var tileset:TiledTileSet = null;
		for (ts in tilesets)
		{
			Assert.info(tileset == null, "Tile map has more than one tileset!");
			tileset = ts;
		}
		Assert.info(tileset != null, "Tile map has no tileset!");
		var tilesetPath = (new Path(filePath)).dir + "/" + tileset.imageSource;
		
		for (tileLayer in layers)
		{
			if (tileLayer.name == "foreground")
			{
				Assert.info(foreground == null, "Second foreground layer found in tile map");
				foreground = new CollidableTilemap();
				foreground.widthInTiles = width;
				foreground.heightInTiles = height;
				foreground.loadMap(tileLayer.tileArray, tilesetPath, tileset.tileWidth, tileset.tileHeight, FlxTilemap.OFF, 1, 1, 1);
			}
			else
			{
				var tilemap = new FlxTilemap();
				tilemap.widthInTiles = width;
				tilemap.heightInTiles = height;
				tilemap.loadMap(tileLayer.tileArray, tilesetPath, tileset.tileWidth, tileset.tileHeight, FlxTilemap.OFF, 1, 1, 1);
				backgroundTiles.push(tilemap);
				background.add(tilemap);
			}
		}
		
		Assert.info(foreground != null, "No foreground layer found in tilemap");
	}
	
	public function loadObjects():Void
	{
		for (group in objectGroups)
		{
			for (o in group.objects)
			{
				if (o.name == "spawn")
				{
					Assert.info(o.custom.contains("id"), "Spawn at (" + o.x + "," + o.y + ") missing id property");
					spawnPoints[o.custom.get("id")] = new FlxPoint(o.x + o.width / 2, o.y + o.height / 2);
				}
				else if (o.name == "tank")
				{
					state.add(new TankEnemy(state, o.x, o.y));
				}
				else if (o.name == "blob")
				{
					state.add(new BlobEnemy(state, o.x, o.y));
				}
				else if (o.name == "hive")
				{
					state.add(new HiveEnemy(state, o.x, o.y));
				}
				else if (o.name == "teleporter")
				{
					Assert.info(o.custom.contains("level"), "Teleporter at (" + o.x + "," + o.y + ") missing level property");
					Assert.info(o.custom.contains("spawn"), "Teleporter at (" + o.x + "," + o.y + ") missing spawn property");
					state.add(new Teleporter(state, o.x, o.y, o.width, o.height, o.custom.get("level"), o.custom.get("spawn")));
				}
				else if (o.name == "dialogue")
				{
					Assert.info(o.custom.contains("id"), "Dialog at (" + o.x + "," + o.y + ") missing id property");
					state.add(new InteractiveDialogue(state, o.x, o.y, o.custom.get("id")));
				}
			}
		}
	}
}