package;

import sys.io.File;
import haxe.Json;

class DialogDictionary
{
	private static var PATH:String = "assets/dialogue/testdialogue.json";
	
	private var stringMap:Map<String, String>;
	
	public function new() 
	{
		stringMap = new Map<String, String>();
		
		var dialogueFile:String = File.getContent(PATH);
		var dialogueJSON:Dynamic = Json.parse(dialogueFile);
		
		for (key in Reflect.fields(dialogueJSON))
		{
			var value:String = Reflect.field(dialogueJSON, key);
			stringMap[key] = value;
		}
	}
	
	public function getString(key:String):String
	{
		return stringMap[key];
	}
}