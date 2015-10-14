package collision;

import haxe.ds.Vector;

import flixel.FlxObject;
import flixel.tile.FlxTilemap;
import flixel.util.FlxPoint;

import collision.ICustomCollidable;
import collision.CollisionFlags;

class CollidableTilemap extends FlxTilemap implements ICustomCollidable
{
	private var _distance:Vector<Float>;
	private var _parents:Vector<Int>;
	public override function loadMap(MapData:Dynamic, TileGraphic:Dynamic, TileWidth:Int = 0, TileHeight:Int = 0, AutoTile:Int = 0, StartingIndex:Int = 0, DrawIndex:Int = 1, CollideIndex:Int = 1):FlxTilemap
	{
		var tilemap = super.loadMap(MapData, TileGraphic, TileWidth, TileHeight, AutoTile, StartingIndex, DrawIndex, CollideIndex);
		
		_distance = new Vector<Float>(widthInTiles * heightInTiles);
		_parents = new Vector<Int>(widthInTiles * heightInTiles);
		
		return tilemap;
	}
	
	public function getCollisionFlags():Int
	{
		return CollisionFlags.SOLID | CollisionFlags.NOCUSTOM;
	}
	
	public function onCollision(other:ICollidable):Void
	{}
	
	public function collisionOverlaps(other:FlxObject):Bool
	{
		return overlaps(other);
	}
	
	public function _raycast(start:FlxPoint, direction:FlxPoint, result:FlxPoint = null, resultInTiles:FlxPoint = null, maxTilesToCheck:Int = -1):Bool
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
	
	private function _heuristic(index:Int, endIndex:Int):Float
	{
		return Math.sqrt(Math.pow(index % widthInTiles - endIndex % widthInTiles, 2) + Math.pow(Math.floor(index / widthInTiles) - Math.floor(endIndex / widthInTiles), 2));
	}
	
	private static function _popPriorityQueue(queue:Array<Int>, distance:Vector<Float>):Int
	{
		var value:Int = queue[0];
		queue[0] = queue[queue.length - 1];
		queue.pop();
		
		// percolate down
		var pos:Int = 0;
		var current:Int = -1;
		var leftIndex:Int = -1;
		var left:Int = -1;
		var rightIndex:Int = -2;
		var right:Int = -1;
		while (pos < queue.length)
		{
			current = queue[pos];
			leftIndex = 2 * pos + 1;
			rightIndex = 2 * pos + 2;
			
			if (leftIndex < queue.length)
			{
				left = queue[leftIndex];
			}
			else
			{
				left = -1;
			}
			
			if (rightIndex < queue.length)
			{
				right = queue[rightIndex];
			}
			else
			{
				right = -1;
			}
			
			if (left != -1 && (right == -1 || distance[left] <= distance[right]) && distance[left] < distance[current])
			{
				queue[leftIndex] = current;
				queue[pos] = left;
				pos = leftIndex;
			}
			else if (right != -1 && (left == -1 || distance[right] < distance[left]) && distance[right] < distance[current])
			{
				queue[rightIndex] = current;
				queue[pos] = right;
				pos = rightIndex;
			}
			else
			{
				break;
			}
		}
		
		return value;
	}
	
	private static function _pushPriorityQueue(queue:Array<Int>, index:Int, distance:Vector<Float>):Void
	{
		var pos = queue.length;
		queue.push(index);
		
		// percolate up
		var current:Int = -1;
		var parentIndex:Int = -1;
		var parent:Int = -1;
		while (pos > 0)
		{
			current = queue[pos];
			parentIndex = Math.floor((pos - 1) / 2);
			parent = queue[parentIndex];
			if (distance[current] < distance[parent])
			{
				queue[parentIndex] = current;
				queue[pos] = parent;
				pos = parentIndex;
			}
			else
			{
				break;
			}
		}
	}
	
	public function _aStarInternal(startIndex:Int, endIndex:Int):Array<FlxPoint>
	{
		var tileCount:Int = widthInTiles * heightInTiles;
		for (i in 0...tileCount)
		{
			if (_tileObjects[_data[i]].allowCollisions == FlxObject.NONE)
			{
				_distance[i] = widthInTiles + heightInTiles;
			}
			else
			{
				_distance[i] = -1;
			}
			_parents[i] = -1;
		}
		_distance[startIndex] = _heuristic(startIndex, endIndex);
		
		var queue:Array<Int> = new Array<Int>();
		queue.push(startIndex);
		
		while (queue.length > 0 && _parents[endIndex] == -1)
		{
			var current = _popPriorityQueue(queue, _distance);
			var cx = current % widthInTiles;
			var cy = Math.floor(current / widthInTiles);
			var totalDist = _distance[current];
			var g = totalDist - _heuristic(current, endIndex);
			
			var rightIndex = cy * widthInTiles + (cx + 1);
			var leftIndex = cy * widthInTiles + (cx - 1);
			var downIndex = (cy + 1) * widthInTiles + cx;
			var upIndex = (cy - 1) * widthInTiles + cx;
			
			var rightDist = 1 + g + _heuristic(rightIndex, endIndex);
			var leftDist = 1 + g + _heuristic(leftIndex, endIndex);
			var downDist = 1 + g + _heuristic(downIndex, endIndex);
			var upDist = 1 + g + _heuristic(upIndex, endIndex);
			
			if (rightDist < _distance[rightIndex])
			{
				_distance[rightIndex] = rightDist;
				_pushPriorityQueue(queue, rightIndex, _distance);
				_parents[rightIndex] = current;
			}
			if (leftDist < _distance[leftIndex])
			{
				_distance[leftIndex] = leftDist;
				_pushPriorityQueue(queue, leftIndex, _distance);
				_parents[leftIndex] = current;
			}
			if (downDist < _distance[downIndex])
			{
				_distance[downIndex] = downDist;
				_pushPriorityQueue(queue, downIndex, _distance);
				_parents[downIndex] = current;
			}
			if (upDist < _distance[upIndex])
			{
				_distance[upIndex] = upDist;
				_pushPriorityQueue(queue, upIndex, _distance);
				_parents[upIndex] = current;
			}
		}
		
		if (_parents[endIndex] == -1)
		{
			return null;
		}
		
		var path = new Array<Int>();
		var current = endIndex;
		while (current != -1)
		{
			path.push(current);
			current = _parents[current];
		}
		
		var points = new Array<FlxPoint>();
		for (tile in path)
		{
			var tx = tile % widthInTiles;
			var ty = Math.floor(tile / widthInTiles);
			
			var left = ty * widthInTiles + (tx - 1);
			var right = ty * widthInTiles + (tx + 1);
			var down = (ty + 1) * widthInTiles + tx;
			var up = (ty - 1) * widthInTiles + tx;
			
			var bottomleft = (ty + 1) * widthInTiles + (tx - 1);
			var bottomright = (ty + 1) * widthInTiles + (tx + 1);
			var topleft = (ty - 1) * widthInTiles + (tx - 1);
			var topright = (ty - 1) * widthInTiles + (tx + 1);
			
			var bumpLeft:Bool = (_distance[topleft] < 0) || (_distance[left] < 0) || (_distance[bottomleft] < 0);
			var bumpRight:Bool = (_distance[topright] < 0) || (_distance[right] < 0) || (_distance[bottomright] < 0);
			var bumpTop:Bool = (_distance[topleft] < 0) || (_distance[up] < 0) || (_distance[topright] < 0);
			var bumpBottom:Bool = (_distance[bottomleft] < 0) || (_distance[down] < 0) || (_distance[bottomright] < 0);
			
			points.unshift(
				new FlxPoint(
					x + (tx + 0.5 + (bumpLeft ? 0.5 : 0) - (bumpRight ? 0.5 : 0)) * _scaledTileWidth,
					y + (ty + 0.5 + (bumpTop ? 0.5 : 0) - (bumpBottom ? 0.5 : 0)) * _scaledTileHeight
				)
			);
		}
		
		return points;
	}
	
	public override function findPath(start:FlxPoint, end:FlxPoint, simplify:Bool = true, raySimplify:Bool = true, wideDiagonal:Bool = true):Array<FlxPoint>
	{
		// Ignores wide diagonal
		var startIndex:Int = Std.int((start.y - y) / _scaledTileHeight) * widthInTiles + Std.int((start.x - x) / _scaledTileWidth);
		var endIndex:Int = Std.int((end.y - y) / _scaledTileHeight) * widthInTiles + Std.int((end.x - x) / _scaledTileWidth);
		
		if ((_tileObjects[_data[startIndex]].allowCollisions > 0) || (_tileObjects[_data[endIndex]].allowCollisions > 0))
		{
			return null;
		}
		
		var points:Array<FlxPoint> = _aStarInternal(startIndex, endIndex);
		
		if (points == null)
		{
			return null;
		}
		
		points[0].x = start.x;
		points[0].y = start.y;
		points[points.length - 1].x = end.x;
		points[points.length - 1].y = end.y;
		
		if (simplify)
		{
			simplifyPath(points);
		}
		if (raySimplify)
		{
			raySimplifyPath(points);
		}
		
		var path = new Array<FlxPoint>();
		
		for (point in points)
		{
			if (point != null)
			{
				path.push(point);
			}
		}
		
		return path;
	}
}