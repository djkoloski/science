package;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.util.FlxColor;
import flixel.util.FlxAngle;

class InteractableDialogueBox extends FlxSprite
{
	private var state:PlayState;
	public var interact: Bool;
	public var player:Player;
	public var playerOverlap:Bool;
	public var dialogueManager:DialogueManager;
	public var text: String;
	public var dialogue: String;
	
	public function new(playState:PlayState, ID:String, X, Y)
	{
		super(X, Y);
		makeGraphic(32, 32, FlxColor.BROWN);
		
		
		state = playState;
		interact = false;
		playerOverlap = false;
		text = ID;
		
		player = state.player;
		dialogueManager = state.dialogueManager;
		
		
		
	}
	
	public function interaction()
	{
			if (interact == true && FlxG.keys.justPressed.SPACE)
			{
				dialogueManager.closeDialogue();
				interact = false;
				
			}
			else if (interact == false && FlxG.keys.justPressed.SPACE && playerOverlap)
			{
				dialogueManager.addDialogue(text);
				dialogueManager.openDialogue();
				interact = true;
			}
		
	}
	public function playerOnObject()
	{
	if (player.overlaps(this, false))
	{
		playerOverlap = true;
		
	}
	else
	{
		playerOverlap = false;
	}
	}
	public override function update()
	{
		playerOnObject();
		interaction();
	}

}
