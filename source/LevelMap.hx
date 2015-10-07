package;

import haxe.io.Path;
import flixel.FlxG;
import flixel.FlxObject;
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
				if (o.name == "player_start")
				{
					startX = o.x;
					startY = o.y;
					
					state.player.x = startX;
					state.player.y = startY;
				}
				else if (o.name == "test")
				{
					enemyGroup.add(new Testenemy(state, o.x, o.y));
				}
				else if (o.name == "teleporter")
				{
					Assert.info(o.custom.contains("location"), "Teleporter missing location");
					state.teleporters.push(new Teleporter(state, o.x, o.y, o.width, o.height, o.custom.get("location")));
				}
			}
		}
	}
	
	public function collideWith(obj:FlxObject, ?notifyCallback:FlxObject->FlxObject->Void, ?processCallback:FlxObject->FlxObject->Bool):Bool
	{
		if (processCallback == null)
		{
			processCallback = FlxObject.separate;
		}
		
		return FlxG.overlap(foregroundTiles, obj, notifyCallback, processCallback);
	}
}