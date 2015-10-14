package;

/**
 * ...
 * @author ...
 */
class MachineGunCollectible extends Collectible
{
	public var dialogue:String;
	
	public function new(state:PlayState, x:Float, y:Float, dialogue:String) 
	{
		super(state, x, y, AssetPaths.heartpickup__png);
		this.dialogue = dialogue;
	}
	
	public override function onCollect():Void
	{
		state.dialogueManager.startDialogue(dialogue);
		state.player.machineGun.locked = false;
		destroy();
	}
	
}