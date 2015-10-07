package;

class PlayerHUD extends StatsHUD
{
	public function new(player:Player)
	{
		x = 5;
		y = 5;
		center = false;
		fixed = true;
		heartSizeX = 25;
		heartSizeY = 25;
		heartSpacing = 5;
		barSpacing = 7;
		barBorder = 2;
		barSizeY = 10;
		barScaleX = 4.0;
		
		super(player.stats);
	}
}