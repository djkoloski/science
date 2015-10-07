package;
import flixel.FlxSprite;
import flixel.util.FlxColor;

/**
 * ...
 * @author ...
 */
class Collectible extends FlxSprite
{
	
	private var type:String;

	public function new(x:Float, y:Float, t:String = "health") 
	{
		super();
		this.x = x;
		this.y = y;
		type = t;
		if (type == "health") {
			this.makeGraphic(20, 20, FlxColor.PINK);
		} else {
			this.makeGraphic(20, 20, FlxColor.KHAKI);
		}
	}
	
	public function getType():String 
	{
		return type;
	}
	
	public function setType(t:String):Void 
	{
		type = t;
	}
}