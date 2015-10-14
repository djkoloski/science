package;

class InteractiveDialogue extends Interactive
{
	public var dialogueId:String;
	
	public function new(state:PlayState, startX:Float, startY:Float, dialogueId:String)
	{
		var npcImage:String = null;
		if (Math.round(startX + startY) % 2 == 0)
		{
			npcImage = AssetPaths.male_npc__png;
		}
		else
		{
			npcImage = AssetPaths.female_npc__png;
		}
		
		super(state, startX, startY, npcImagew);
		
		this.dialogueId = dialogueId;
	}
	
	public override function onInteraction():Void
	{
		state.dialogueManager.startDialogue(dialogueId, function() { trace("Done!"); });
	}
}