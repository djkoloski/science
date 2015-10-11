package;

class InteractiveDialogue extends Interactive
{
	public var dialogueId:String;
	
	public function new(state:PlayState, startX:Float, startY:Float, dialogueId:String)
	{
		super(state, startX, startY, "assets/images/heartpickup.png");
		
		this.dialogueId = dialogueId;
	}
	
	public override function onInteraction():Void
	{
		state.dialogueManager.startDialogue(dialogueId, function() { trace("Done!"); });
	}
}