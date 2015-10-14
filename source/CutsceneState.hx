package;

import flixel.FlxState;
import flixel.FlxSprite;
import flixel.FlxG;

class CutsceneState extends FlxState
{
	public var toState:FlxState;
	public var imagePath:String;
	public var image:FlxSprite;
	
	public function new(toState:FlxState, imagePath:String)
	{
		super();
		
		this.toState = toState;
		this.imagePath = imagePath;
	}
	
	public override function create()
	{
		this.image = new FlxSprite();
		this.image.loadGraphic(imagePath);
		
		add(this.image);
	}
	
	public override function update()
	{
		super.update();
		
		if (FlxG.keys.justPressed.SPACE)
		{
			FlxG.switchState(toState);
		}
	}
}