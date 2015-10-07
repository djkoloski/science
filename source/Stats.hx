package;

import flixel.FlxG;

class Stats
{
	private var hearts:Int;
	private var residualMax:Float;
	private var residualCurrent:Float;
	private var regen:Float;

	public function new(h:Int = 3, resMax:Float = 30.0, resCurr:Float = 0.0, reg:Float = 2) 
	{
		hearts = h;
		residualMax = resMax;
		residualCurrent = resCurr;
		regen = reg;
	}
	
	public function isDead():Bool
	{
		return hearts <= 0;
	}
	
	public function getHearts():Int
	{
		return hearts;
	}
	
	public function getMaxResidual():Float
	{
		return residualMax;
	}
	
	public function getCurrentResidual():Float
	{
		return residualCurrent;
	}
	
	public function getRegen():Float
	{
		return regen;
	}
	
	public function setRegen(r:Float = 0):Void
	{
		regen = r;
	}
	
	public function setResidual(r:Float = 0):Void
	{
		if (r < 0)
		{
			r = 0;
		}
		
		residualCurrent = r % residualMax;
		hearts -= Math.floor(r / residualMax);
	}
	
	public function update():Void
	{
		setResidual(residualCurrent - regen * FlxG.elapsed);
	}
}