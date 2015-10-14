package;

import flixel.FlxState;
import flixel.FlxSprite;
import flixel.FlxG;

class CutsceneState extends FlxState
{
	public var toState:FlxState;
	public var imagePath:String;
	public var image:FlxSprite;
	public var dialogue:DialogueDictionary;
	public var dialogueManager:DialogueManager;
	public var id:String;
	
	public function new(toState:FlxState, imagePath:String, id:String)
	{
		super();
		
		this.toState = toState;
		this.imagePath = imagePath;
		this.dialogue = new DialogueDictionary();
		this.id = id;
	}
	
	public override function create()
	{
		this.image = new FlxSprite();
		this.image.loadGraphic(imagePath);
		
		this.dialogueManager = new DialogueManager(dialogue);
		
		add(this.image);
		add(this.dialogueManager);
		
		this.dialogueManager.startDialogue(id, this.advance);
	}
	
	public override function update()
	{
		super.update();
	}
	
	public function advance()
	{
		FlxG.switchState(toState);
	}
}