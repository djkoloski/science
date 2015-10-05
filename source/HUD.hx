package;

import flixel.FlxGroup;
import flixel.FlxSprite;
/**
 * ...
 * @Nanyou ...
 */
class HUD extends FlxGroup
{
	var heart:FlxSprite;
	var barFrame:FlxSprite;
	var barBackground:FlxSprite;
	var barForeground:FlxSprite;
	
	public function new() 
	{
		heart = new FlxSprite(5, 5, HeartImage);
		heart.scrollFactor.x = heart.scrollFactor.y = 0;
		barFrame = new FlxSprite(5, 15);
		barBackground = new FlxSprite(6, 16);
		barForeground = new FlxSprite(6, 16);
		
	}
	
}