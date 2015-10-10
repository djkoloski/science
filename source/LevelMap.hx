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

class LevelMap extends TiledMap
{
	public var state:PlayState;
	
	public var foregroundTiles:FlxTilemap;
	public var foregroundGroup:FlxGroup;
	public var backgroundTiles:Array<FlxTilemap>;
	public var backgroundGroup:FlxGroup;
	
	public var spawnPoints:Map<String, FlxPoint>;
	
	public var enemyGroup:FlxGroup;
	
	public var startX:Float;
	public var startY:Float;
	
	public function new(playState:PlayState, filePath:Dynamic)
	{
		super(filePath);
		
		state = playState;
		
		foregroundTiles = null;
		foregroundGroup = new FlxGroup();
		backgroundTiles = new Array<FlxTilemap>();
		backgroundGroup = new FlxGroup();
		
		spawnPoints = new Map<String, FlxPoint>();
		
		enemyGroup = new FlxGroup();
		
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
			var tilemap = new FlxTilemap();
			tilemap.widthInTiles = width;
			tilemap.heightInTiles = height;
			tilemap.loadMap(tileLayer.tileArray, tilesetPath, tileset.tileWidth, tileset.tileHeight, FlxTilemap.OFF, 1, 1, 1);
			
			if (tileLayer.name == "foreground")
			{
				Assert.info(foregroundTiles == null, "Foreground layer added while there is already a foreground layer. Only one foreground layer is allowed.");
				foregroundTiles = tilemap;
				foregroundGroup.add(foregroundTiles);
			}
			else
			{
				backgroundTiles.push(tilemap);
				backgroundGroup.add(tilemap);
			}
		}
		
		Assert.info(foregroundTiles != null, "No foreground layer found in tilemap");
		
		for (group in objectGroups)
		{
			for (o in group.objects)
			{
				if (o.name == "spawn")
				{
					Assert.info(o.custom.contains("id"), "Spawn at (" + o.x + "," + o.y + ") missing id property");
					spawnPoints[o.custom.get("id")] = new FlxPoint(o.x + o.width / 2, o.y + o.height / 2);
				}
				else if (o.name == "test")
				{
					enemyGroup.add(new Testenemy(state, o.x, o.y));
				}
				else if (o.name == "teleporter")
				{
					Assert.info(o.custom.contains("level"), "Teleporter at (" + o.x + "," + o.y + ") missing level property");
					Assert.info(o.custom.contains("spawn"), "Teleporter at (" + o.x + "," + o.y + ") missing spawn property");
					state.teleporters.push(new Teleporter(state, o.x, o.y, o.width, o.height, o.custom.get("level"), o.custom.get("spawn")));
				}
			}
		}
	}
	
	public function collideWith(obj:FlxBasic, ?notifyCallback:Dynamic->Dynamic->Void, ?processCallback:Dynamic->Dynamic->Bool):Bool
	{
		if (processCallback == null)
		{
			processCallback = FlxObject.separate;
		}
		
		return FlxG.overlap(foregroundTiles, obj, notifyCallback, processCallback);
	}
}