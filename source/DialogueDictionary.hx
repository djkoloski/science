package;

import sys.io.File;
import haxe.Json;

class DialogueDictionary
{
	private static var PATH:String = "assets/dialogue/testdialogue.json";
	
	private var map:Map<String, Dialogue>;
	
	public function new() 
	{
		map = new Map<String, Dialogue>();
		
		var dialogueFile:String = File.getContent(PATH);
		var dialogueJSON:Dynamic = Json.parse(dialogueFile);
		
		for (key in Reflect.fields(dialogueJSON))
		{
			var lines:Array<String> = Reflect.field(dialogueJSON, key);
			var dialogue = new Dialogue();
			for (line in lines)
			{
				dialogue.addFrame(new DialogueFrame(line));
			}
			map[key] = dialogue;
		}
	}
	
	public function get(key:String):Dialogue
	{
		return map[key];
	}
}