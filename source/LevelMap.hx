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
	public var tileLayers:Array<FlxTilemap>;
	public var foregroundTiles:FlxGroup;
	public var backgroundTiles:FlxGroup;
	
	public function new(path:Dynamic) 
	{
		super(path);
		
		tileLayers = new Array<FlxTilemap>();
		foregroundTiles = new FlxGroup();
		backgroundTiles = new FlxGroup();
		collidableTileLayers = new FlxGroup();
		
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
				foregroundTiles.add(tilemap);
			}
			else
			{
				backgroundTiles.add(tilemap);
			}
		}
		
		for (group in objectGroups)
		{
			for (o in group.objects)
			{
				// TODO: process objects
			}
		}
	}
	
	public function collideWithLevel(obj:FlxObject, ?notifyCallback:FlxObject->FlxObject->Void, ?processCallback:FlxObject->FlxObject->Bool):Bool
	{
		if (processCallback == null)
		{
			processCallback = FlxObject.separate;
		}
		
		return FlxG.overlap(foregroundTiles, obj, notifyCallback, processCallback);
	}
}