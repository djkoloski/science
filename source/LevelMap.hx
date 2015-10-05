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
	public var foregroundTiles:Array<FlxTilemap>;
	public var foregroundGroup:FlxGroup;
	public var backgroundTiles:Array<FlxTilemap>;
	public var backgroundGroup:FlxGroup;
	
	public var startX:Float;
	public var startY:Float;
	
	public function new(path:Dynamic) 
	{
		super(path);
		
		foregroundTiles = new Array<FlxTilemap>();
		foregroundGroup = new FlxGroup();
		backgroundTiles = new Array<FlxTilemap>();
		backgroundGroup = new FlxGroup();
		
		var tileset:TiledTileSet = null;
		for (ts in tilesets)
		{
			Assert.info(tileset == null, "Tile map has more than one tileset!");
			tileset = ts;
		}
		Assert.info(tileset != null, "Tile map has no tileset!");
		var tilesetPath = (new Path(path)).dir + "/" + tileset.imageSource;
		trace("Tile set image path: '" + tilesetPath + "'");
		
		for (tileLayer in layers)
		{
			trace(tileLayer.name);
			
			var tilemap = new FlxTilemap();
			tilemap.widthInTiles = width;
			tilemap.heightInTiles = height;
			tilemap.loadMap(tileLayer.tileArray, tilesetPath, tileset.tileWidth, tileset.tileHeight, FlxTilemap.OFF, 1, 1, 1);
			
			if (tileLayer.name == "foreground")
			{
				foregroundTiles.push(tilemap);
				foregroundGroup.add(tilemap);
			}
			else
			{
				backgroundTiles.push(tilemap);
				backgroundGroup.add(tilemap);
			}
		}
		
		for (group in objectGroups)
		{
			for (o in group.objects)
			{
				if (o.name == "player_start")
				{
					startX = o.x;
					startY = o.y;
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
		
		for (tilemap in foregroundTiles)
		{
			if (FlxG.overlap(tilemap, obj, notifyCallback, processCallback))
			{
				return true;
			}
		}
		return false;
	}
}