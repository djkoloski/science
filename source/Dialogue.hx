package;

class Dialogue
{
	public var frames:Array<DialogueFrame>;
	
	public function new() 
	{
		frames = new Array<DialogueFrame>();
	}
	
	public function addFrame(frame:DialogueFrame):Void
	{
		frames.push(frame);
	}
}