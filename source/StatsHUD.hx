package;

import flixel.group.FlxGroup;
import flixel.FlxSprite;
import flixel.FlxBasic;

class StatsHUD extends FlxGroup
{
	var stats:Stats;
	var hearts:Array<FlxSprite>;
	var barFrame:FlxSprite;
	var barBackground:FlxSprite;
	var barForeground:FlxSprite;
	
	var x:Int;
	var y:Int;
	var center:Bool;
	var fixed:Bool;
	var heartSizeX:Int;
	var heartSizeY:Int;
	var heartSpacing:Int;
	var barSpacing:Int;
	var barBorder:Int;
	var barSizeY:Int;
	var barScaleX:Float;
	var useHeartImage:Bool;
	
	public function new(targetStats:Stats) 
	{
		super();
		
		stats = targetStats;
		hearts = null;
		barFrame = null;
		barBackground = null;
		barForeground = null;
		
		updateGUI();
	}
	
	public function updateGUI():Void
	{
		var barMaxSize = Math.floor(stats.getMaxResidual() * barScaleX / 2.0) * 2;
		var barCurrentSize = Math.floor(stats.getCurrentResidual() * barScaleX / 2.0) * 2;
		
		var offsetX = (center ? -barMaxSize / 2 : 0);
		
		if (hearts == null || stats.getHearts() != hearts.length)
		{
			if (hearts != null)
			{
				for (heart in hearts)
				{
					heart.destroy();
				}
			}
			hearts = new Array<FlxSprite>();
			for (i in 0...stats.getHearts())
			{
				var heart = new FlxSprite();
				add(heart);
				if (!useHeartImage)
				{
					heart.makeGraphic(heartSizeX, heartSizeY, 0xffff0000);
				}
				else
				{
					heart.loadGraphic(AssetPaths.heart_icon__png);
				}
				if (fixed)
				{
					heart.scrollFactor.x = heart.scrollFactor.y = 0;
				}
				hearts.push(heart);
			}
		}
		for (i in 0...hearts.length)
		{
			hearts[i].x = x + offsetX + (heartSizeX + heartSpacing) * i;
			hearts[i].y = y;
		}
		
		if (barFrame == null)
		{
			barFrame = new FlxSprite();
			add(barFrame);
			barFrame.makeGraphic(1, barSizeY + barBorder * 2, 0xff000000);
			if (fixed)
			{
				barFrame.scrollFactor.x = barFrame.scrollFactor.y = 0;
			}
			barFrame.origin.x = barFrame.origin.y = 0;
		}
		barFrame.x = x + offsetX - barBorder;
		barFrame.y = y + heartSizeY + barSpacing - barBorder;
		barFrame.scale.x = barMaxSize + barBorder * 2;
		
		if (barBackground == null)
		{
			barBackground = new FlxSprite();
			add(barBackground);
			barBackground.makeGraphic(1, barSizeY, 0xff666666);
			if (fixed)
			{
				barBackground.scrollFactor.x = barBackground.scrollFactor.y = 0;
			}
			barBackground.origin.x = barBackground.origin.y = 0;
		}
		barBackground.x = x + offsetX;
		barBackground.y = y + heartSizeY + barSpacing;
		barBackground.scale.x = barMaxSize;
		
		if (barForeground == null)
		{
			barForeground = new FlxSprite();
			add(barForeground);
			barForeground.makeGraphic(1, barSizeY, 0xffff0000);
			if (fixed)
			{
				barForeground.scrollFactor.x = barForeground.scrollFactor.y = 0;
			}
			barForeground.origin.x = barForeground.origin.y = 0;
		}
		barForeground.x = x + offsetX;
		barForeground.y = y + heartSizeY + barSpacing;
		barForeground.scale.x = barCurrentSize;
	}
	
	public override function update()
	{
		super.update();
		updateGUI();
	}
}