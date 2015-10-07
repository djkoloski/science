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
	public var foregroundTiles:FlxTilemap;
	public var foregroundGroup:FlxGroup;
	public var backgroundTiles:Array<FlxTilemap>;
	public var backgroundGroup:FlxGroup;
	
	public var enemyGroup:FlxGroup;
	
	public var startX:Float;
	public var startY:Float;
	
	public function new(filePath:Dynamic,playstate:PlayState) 
	{
		super(filePath);
		
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
				}
				else 
				{
					if (o.name == "test") 
					{
						enemyGroup.add(new Testenemy(playstate,o.x, o.y));
					}
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