package;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.util.FlxColor;
import flixel.util.FlxAngle;
import flixel.group.FlxGroup;

class DialogueManager extends FlxGroup
{
	public var width: Int = Std.int(FlxG.width/2);
	public var height: Int =Std.int(FlxG.height / 4);

	
	public var boxForeground: FlxSprite;
	public var boxBackground: FlxSprite;
	public var dialogue: String;
	public var dialogueBox:FlxText;
	
	public function new(dialogue:String)
	{
		super();
		var backgroundWidth:Int = Std.int(width + (width / 8));
		var backgroundHeight:Int = Std.int(height + (height / 8));
		var X: Float = FlxG.width/4;
		var Y: Float = FlxG.height/8 * 6;
		
		boxForeground = new FlxSprite(X,Y);
		boxForeground.makeGraphic(width,height,FlxColor.WHITE);
		boxForeground.scrollFactor.x = boxForeground.scrollFactor.y = 0; 
		
		boxBackground = new FlxSprite(X, Y);
		boxBackground.makeGraphic(backgroundWidth,backgroundHeight, FlxColor.BLACK);
		boxBackground.scrollFactor.x = boxBackground.scrollFactor.y = 0; 
		
		//add(boxBackground);
		add(boxForeground);
		
		dialogueBox = new FlxText(X, Y, width);
		dialogueBox.color = FlxColor.BLACK;
		dialogueBox.text = dialogue;
		add(dialogueBox);
	}
	public override function update()
	{
		if (FlxG.keys.pressed.SPACE)
		{
			remove(boxBackground);
			remove(boxForeground);
			remove(dialogueBox);
		}
	}

}