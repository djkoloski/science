package;

import sys.io.File;
import haxe.Json;

class DialogueDictionary
{
	private static var PATH:String = "assets/dialogue/testdialogue.json";
	
	private var stringMap:Map<String, String>;
	
	public function new() 
	{
		var dialogueFile:String = File.getContent(PATH);
		var dialogueJSON:Dynamic = Json.parse(dialogueFile);
		
		trace(dialogueJSON);
		trace("Dialogue JSON is a " + Type.getClass(dialogueJSON));
		
		for (key in Reflect.fields(dialogueJSON))
		{
			trace(key);
			var value:String = Reflect.getProperty(dialogueJSON, key);
			stringMap[key] = value;
			
			trace(key + " = " + value);
		}
	}
	
	public function getString(key:String):String
	{
		return stringMap[key];
	}
}