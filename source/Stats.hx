package;

import flixel.FlxG;

/**
 * ...
 * @author ...
 */
class Stats
{
	
	private var hearts:Int;
	private var residualMax:Int;
	private var residualCurrent:Int;
	private var regen:Int;
	private var counter:Float;

	public function new(h:Int = 3, resMax:Int = 30, resCurr:Int = 0, reg:Int = 2) 
	{
		hearts = h;
		residualMax = resMax;
		residualCurrent = resCurr;
		regen = reg;
		counter = 0;
	}
	
	public function getHearts():Int {
		return hearts;
	}
	
	public function getMaxResidual():Int {
		return residualMax;
	}
	
	public function getCurrentResidual():Int {
		return residualCurrent;
	}
	
	public function getRegen():Int {
		return regen;
	}
	
	public function setRegen(r:Int = 0):Void {
		regen = r;
	}
	
	public function addResidual(r:Int = 0):Void {
		residualCurrent += r;
	}
	
	public function update():Void {
		if (residualCurrent >= residualMax) {
			residualCurrent = residualCurrent - residualMax;
			hearts--;
		}
		/*
		if (residualCurrent > 0) {
			residualCurrent -= regen;
		}
		*/
		if (residualCurrent < 0) {
			residualCurrent = 0;
		}
		
		counter += FlxG.elapsed;
		if (counter >= 1) {
			if (residualCurrent > 0) {
				residualCurrent -= regen;
			}
			counter = 0;
		}
	}
}