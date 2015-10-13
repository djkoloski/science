package;
import flixel.FlxSprite;
import flixel.util.FlxColor;

class PlayerHUD extends StatsHUD
{
	var currentWeapon:FlxSprite;
	var p:Player;
	
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
		currentWeapon = new FlxSprite(130, 35);
		currentWeapon.scrollFactor.x = currentWeapon.scrollFactor.y = 0;
		p = player;
		
		super(player.stats);
	}
	
	override public function update() 
	{
		super.update();
		add(currentWeapon);
		if (p.weapon == p.laser)
		{
			currentWeapon.makeGraphic(25, 25, FlxColor.RED);
		} 
		else if (p.weapon == p.rocketLauncher)
		{
			currentWeapon.makeGraphic(25, 25, FlxColor.GREEN);
		}
		else if (p.weapon == p.sniper)
		{
			currentWeapon.makeGraphic(25, 25, FlxColor.GRAY);
		}
		else if (p.weapon == p.shotgun)
		{
			currentWeapon.makeGraphic(25, 25, FlxColor.CORAL);
		}
	}
}