package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.group.FlxGroup;
import flixel.util.FlxColor;
import flixel.util.FlxAngle;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState
{
	public var player:Player;
	public var weapon: Weapon;
	public var weapons =  new FlxGroup(100);
	private var bullet_delay:Float = 0;
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		//Add Player		
		player = new Player(20, 20);
		add(player);
		
	}
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		super.destroy();
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void
	{
		var bAngle: Float = 0;
		bullet_delay--;
		var primary:Bool = FlxG.keys.justPressed.SPACE;
		var secondary:Bool = FlxG.keys.justPressed.SHIFT;
		
		if (primary)
		{
			weapon = new Weapon(player.x, player.y, player.Angle, 2);
			add(weapon);
			weapons.add(weapon);
		}
		if (secondary)
		{
			weapon = new Weapon(player.x, player.y, player.Angle, 1);
			add(weapon);
			weapons.add(weapon);
		}
		
		
		super.update();
	}	
}