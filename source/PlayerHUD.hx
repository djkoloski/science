package;
import flixel.FlxSprite;
import flixel.util.FlxColor;

class PlayerHUD extends StatsHUD
{
	var currentWeapon:FlxSprite;
	var p:Player;
	
	var cooldownBarFrame:FlxSprite;
	var cooldownBarBackground:FlxSprite;
	var cooldownBarForeground:FlxSprite;
	
	var cooldownBarBorder:Int;
	var cooldownBarSizeY:Int;
	var cooldownBarScaleX:Float;
	
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
		useHeartImage = true;
		cooldownBarBorder = 2;
		cooldownBarSizeY = 5;
		cooldownBarScaleX = 100.0;
		currentWeapon = new FlxSprite(130, 15);
		currentWeapon.scrollFactor.x = currentWeapon.scrollFactor.y = 0;
		p = player;
		
		super(player.stats);
	}
	
	public override function updateGUI():Void
	{
		super.updateGUI();
		
		var cooldownBarMaxSize = Math.floor(p.weapon.getMaxCooldown() * cooldownBarScaleX / 2.0) * 2;
		var cooldownBarCurrentSize = Math.max(0, Math.floor(p.weapon.getCooldown() * cooldownBarScaleX / 2.0)) * 2;
		
		if (cooldownBarFrame == null)
		{
			cooldownBarFrame = new FlxSprite();
			add(cooldownBarFrame);
			cooldownBarFrame.makeGraphic(1, cooldownBarSizeY + cooldownBarBorder * 2, 0xFF000000);
			cooldownBarFrame.scrollFactor.x = cooldownBarFrame.scrollFactor.y = 0;
			cooldownBarFrame.origin.x = cooldownBarFrame.origin.y = 0;
		}
		cooldownBarFrame.x = x - cooldownBarBorder;
		cooldownBarFrame.y = barForeground.y + barForeground.height + barSpacing - cooldownBarBorder;
		cooldownBarFrame.scale.x = cooldownBarMaxSize + cooldownBarBorder * 2;
		
		if (cooldownBarBackground == null)
		{
			cooldownBarBackground = new FlxSprite();
			add(cooldownBarBackground);
			cooldownBarBackground.makeGraphic(1, cooldownBarSizeY, 0xFF666666);
			cooldownBarBackground.scrollFactor.x = cooldownBarBackground.scrollFactor.y = 0;
			cooldownBarBackground.origin.x = cooldownBarBackground.origin.y = 0;
		}
		cooldownBarBackground.x = x;
		cooldownBarBackground.y = cooldownBarFrame.y + cooldownBarBorder;
		cooldownBarBackground.scale.x = cooldownBarMaxSize;
		
		if (cooldownBarForeground == null)
		{
			cooldownBarForeground = new FlxSprite();
			add(cooldownBarForeground);
			cooldownBarForeground.makeGraphic(1, cooldownBarSizeY, 0xFFFFFF00);
			cooldownBarForeground.scrollFactor.x = cooldownBarForeground.scrollFactor.y = 0;
			cooldownBarForeground.origin.x = cooldownBarForeground.origin.y = 0;
		}
		cooldownBarForeground.x = cooldownBarBackground.x;
		cooldownBarForeground.y = cooldownBarBackground.y;
		cooldownBarForeground.scale.x = cooldownBarCurrentSize;
	}
	
	override public function update() 
	{
		super.update();
		add(currentWeapon);
		if (p.weapon == p.laser)
		{
			currentWeapon.loadGraphic("assets/images/Laser.png",false);
		} 
		else if (p.weapon == p.rocketLauncher)
		{
			currentWeapon.loadGraphic("assets/images/Rocket.png",false);
		}
		else if (p.weapon == p.sniper)
		{
			currentWeapon.loadGraphic("assets/images/Sniper.png",false);
		}
		else if (p.weapon == p.shotgun)
		{
			currentWeapon.loadGraphic("assets/images/Shotgun.png",false);
		}
		else if (p.weapon == p.startingGun)
		{
			currentWeapon.loadGraphic("assets/images/Pistol.png",false);
		}
		else if (p.weapon == p.machineGun)
		{
			currentWeapon.loadGraphic("assets/images/MachineGun.png",false);
		}
		else if (p.weapon == p.crowdLaser)
		{
			currentWeapon.loadGraphic("assets/images/PreciseLaser.png",false);
		}
		else if (p.weapon == p.preciseLaser)
		{
			currentWeapon.loadGraphic("assets/images/CrowdLaser.png",false);
		}
	}
}