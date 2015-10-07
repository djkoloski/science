package;

class MobHUD extends StatsHUD
{
	var mob:Mob;
	
	public function new(targetMob:Mob)
	{
		mob = targetMob;
		
		x = Math.round(mob.x + mob.width / 2);
		y = Math.round(mob.y - 20);
		center = true;
		fixed = false;
		heartSizeX = 5;
		heartSizeY = 5;
		heartSpacing = 5;
		barSpacing = 5;
		barBorder = 1;
		barSizeY = 3;
		barScaleX = 1.0;
		
		super(mob.stats);
	}
	
	public override function update()
	{
		x = Math.round(mob.x + mob.width / 2);
		y = Math.round(mob.y - 20);
		
		super.update();
	}
}