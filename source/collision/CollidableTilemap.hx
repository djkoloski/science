package collision;

import flixel.FlxObject;
import flixel.tile.FlxTilemap;
import flixel.util.FlxPoint;

import collision.ICustomCollidable;
import collision.CollisionFlags;

class CollidableTilemap extends FlxTilemap implements ICustomCollidable
{
	public function getCollisionFlags():Int
	{
		return CollisionFlags.SOLID;
	}
	
	public function onCollision(other:ICollidable):Void
	{}
	
	public function collisionOverlaps(other:FlxObject):Bool
	{
		return overlaps(other);
	}
	
	public function raycast(start:FlxPoint, direction:FlxPoint, result:FlxPoint = null, resultInTiles:FlxPoint = null, maxTilesToCheck:Int = -1):Bool
	{
		var cx:Int;
		var cy:Int;
		var cbx:Float;
		var cby:Float;
		var tMaxX:Float;
		var tMaxY:Float;
		var tDeltaX:Float;
		var tDeltaY:Float;
		var stepX:Int;
		var stepY:Int;
		var outX:Float;
		var outY:Float;
		var hitTile:Bool = false;
		var tResult:Float = 0;
		
		if (start == null)
		{
			return false;
		}
		
		if (result == null)
		{
			result = new FlxPoint();
		}
		
		if (direction == null || (direction.x == 0 && direction.y == 0))
		{
			result.x = start.x;
			result.y = start.y;
			return false;
		}
		
		cx = coordsToTileX(start.x);
		cy = coordsToTileY(start.y);
		
		if (!inTileRange(cx, cy))
		{
			result.x = start.x;
			result.y = start.y;
			return false;
		}
		
		if (getTile(cx, cy) > 0)
		{
			result.x = start.x;
			result.y = start.y;
			return true;
		}
		
		if (maxTilesToCheck == -1)
		{
			maxTilesToCheck = widthInTiles * heightInTiles;
		}
		
		if (direction.x > 0)
		{
			stepX = 1;
			outX = widthInTiles;
			cbx = x + (cx + 1) * _tileWidth;
		}
		else
		{
			stepX = -1;
			outX = -1;
			cbx = x + cx * _tileWidth;
		}
		
		if (direction.y > 0)
		{
			stepY = 1;
			outY = heightInTiles;
			cby = y + (cy + 1) * _tileHeight;
		}
		else
		{
			stepY = -1;
			outY = -1;
			cby = y + cy * _tileHeight;
		}
		
		if (direction.x != 0)
		{
			tMaxX = (cbx - start.x) / direction.x;
			tDeltaX = _tileWidth * stepX / direction.x;
		}
		else
		{
			tMaxX = 1000000;
			tDeltaX = 0;
		}
		
		if (direction.y != 0)
		{
			tMaxY = (cby - start.y) / direction.y;
			tDeltaY = _tileHeight * stepY / direction.y;
		}
		else
		{
			tMaxY = 1000000;
			tDeltaY = 0;
		}
		
		var tileCount = 0;
		while (tileCount < maxTilesToCheck)
		{
			if (tMaxX < tMaxY)
			{
				cx += stepX;
				if (getTile(cx, cy) > 0)
				{
					hitTile = true;
					break;
				}
				if (cx == outX)
				{
					hitTile = false;
					break;
				}
				tMaxX += tDeltaX;
			}
			else
			{
				cy += stepY;
				if (getTile(cx, cy) > 0)
				{
					hitTile = true;
					break;
				}
				if (cy == outY)
				{
					hitTile = false;
					break;
				}
				tMaxY += tDeltaY;
			}
			
			++tileCount;
		}
		
		tResult = (tMaxX < tMaxY) ? tMaxX : tMaxY;
		
		result.x = start.x + (direction.x * tResult);
		result.y = start.y + (direction.y * tResult);
		
		if (resultInTiles != null)
		{
			resultInTiles.x = cx;
			resultInTiles.y = cy;
		}
		
		return hitTile;
	}
	
	public function inTileRange(tileX:Float, tileY:Float):Bool
	{
		return (tileX >= 0 && tileX < widthInTiles && tileY >= 0 && tileY < heightInTiles);
	}
	
	public function tileAt(coordX:Float, coordY:Float):Int
	{
		return getTile(Math.floor((coordX - x) / _tileWidth), Math.floor((coordY - y) / _tileHeight));
	}
	
	public function tileIndexAt(coordX:Float, coordY:Float):Int
	{
		var x:Int = Math.floor((coordX - x) / _tileWidth);
		var y:Int = Math.floor((coordY - y) / _tileHeight);
		return y * widthInTiles + x;
	}
	
	public function getTileIndex(x:Int, y:Int):Int
	{
		return y * widthInTiles + x;
	}
	
	public function coordsToTileX(coordX:Float):Int
	{
		return Math.floor((coordX - x) / _tileWidth);
	}
	
	public function coordsToTileY(coordY:Float):Int
	{
		return Math.floor((coordY - y) / _tileHeight);
	}
	
	public function indexToCoordX(index:Float):Float
	{
		return (index % widthInTiles) * _tileWidth + _tileWidth / 2;
	}
	
	public function indexToCoordY(index:Float):Float
	{
		return Math.floor(index / widthInTiles) * _tileHeight + _tileHeight / 2;
	}
}