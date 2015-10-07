package;

import flixel.group.FlxGroup;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.text.FlxText;

class HUD extends FlxGroup
{
	var heart:FlxSprite;
	var barFrame:FlxSprite;
	var barBackground:FlxSprite;
	var barForeground:FlxSprite;
	var barCooldownTimer: FlxSprite;
	
	
	public function new() 
	{
		super();
		
		heart = new FlxSprite(10, 5);
		heart.makeGraphic(1, 10, 0xffff0000);
		heart.scale.x = 25;
		heart.scrollFactor.x = heart.scrollFactor.y = 0;
		
		barFrame = new FlxSprite(5, 25);
		barFrame.makeGraphic(200, 50);
		barFrame.scrollFactor.x = barFrame.scrollFactor.y = 0;
		
		barBackground = new FlxSprite(10, 30);
		barBackground.makeGraphic(190, 40, 0xff000000);
		barBackground.scrollFactor.x = barBackground.scrollFactor.y = 0;
		
		barForeground = new FlxSprite(10, 30);
		barForeground.makeGraphic(1, 40, 0xffff0000);
		barForeground.scrollFactor.x = barForeground.scrollFactor.y = 0;
		barForeground.origin.x = barForeground.origin.y = 0;
		barForeground.scale.x = 190;
		
		barCooldownTimer = new FlxSprite(5,80);
		barCooldownTimer.makeGraphic(200,20,FlxColor.YELLOW);
		barCooldownTimer.scrollFactor.x = barCooldownTimer.scrollFactor.y = 0;
		
		add(heart);
		add(barFrame);
		add(barBackground);
		add(barForeground);
		add(barCooldownTimer);
	}
	
	public override function update()
	{
		barForeground.scale.x = 100;
		barCooldownTimer.makeGraphic(PlayState.bulletCooldown, 20, FlxColor.YELLOW);
	}
}