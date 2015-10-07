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
import flixel.util.FlxTimer;

class DialogueManager extends FlxGroup
{
	public var width: Int = Std.int(FlxG.width/2);
	public var height: Int =Std.int(FlxG.height / 4);

	
	public var boxForeground: FlxSprite;
	public var boxBackground: FlxSprite;
	public var dialogueBox:FlxText;
	public var dialogueOpener: FlxSprite;
	public var state: PlayState;
	public var X:Float;
	public var Y:Float;
	public var timer:FlxTimer;
	
	public function new(playState:PlayState)
	{
		
		super();
		state = playState;
		createDialogueBox();
		

	}
	public function createDialogueBox()
	{
		var foregroundWidth:Int = Std.int(width - (width / 8));
		var foregroundHeight:Int = Std.int(height - (height / 8));
		X = FlxG.width/4;
		Y = FlxG.height;
		
		boxForeground = new FlxSprite(X+ (width/16),Y +(height/16));
		boxForeground.makeGraphic(foregroundWidth,foregroundHeight,FlxColor.WHITE);
		boxForeground.scrollFactor.x = boxForeground.scrollFactor.y = 0; 
		
		boxBackground = new FlxSprite(X, Y);
		boxBackground.makeGraphic(width,height, FlxColor.BLACK);
		boxBackground.scrollFactor.x = boxBackground.scrollFactor.y = 0; 
		
		add(boxBackground);
		add(boxForeground);
	
		boxBackground.visible = false;
		boxForeground.visible = false;
		

	}

	public function closeDialogue()
	{
		
		boxForeground.visible = false;
		boxBackground.visible = false;
		dialogueBox.visible = false;
	}
	public function transitionOntoScreen()
	{
		openDialogue();
		timer = new FlxTimer(3, null, 1);
		while (timer.finished != true)
		{
			Y += 1;
		}
	}
	public function transitionOffScreen()
	{
		timer = new FlxTimer(3, null, 1);
		while (timer.finished != true)
		{
			Y -= 1;
		}
		if (timer.finished == true)
		{
			closeDialogue();
		}
	}
	public function openDialogue()
	{
		boxForeground.visible = true;
		boxBackground.visible = true;
		dialogueBox.visible = true;
	}
	public function IDsearch(Id:String)
	{
		var dialogue: String;
		dialogue = state.dialogue.getString();
		return dialogue;
	}
	public function addDialogue(dialogue:String)
	{
		dialogueBox = new FlxText(X+(width/16), Y+(height/16), width - (width/8));
		dialogueBox.color = FlxColor.BLACK;
		dialogueBox.text = dialogue;
		dialogueBox.visible = false;
	}
}