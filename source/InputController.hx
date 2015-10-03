package;

import flixel.FlxG;
import flixel.util.FlxVector;

/**
 * A basic input controller for the character.
 * @author David Koloski
 */
class InputController
{
	public var movement:FlxVector;
	public var primary:Bool;
	public var secondary:Bool;

	public function update():Void
	{
		movement.set(0, 0);
		primary = false;
		secondary = false;

		if (FlxG.keys.anyPressed(["RIGHT", "D"]))
			movement.x += 1;
		if (FlxG.keys.anyPressed(["LEFT", "A"]))
			movement.x -= 1;
		if (FlxG.keys.anyPressed(["UP", "W"]))
			movement.y += 1;
		if (FlxG.keys.anyPressed(["DOWN", "S"]))
			movement.y -= 1;
		if (FlxG.keys.anyPressed(["SPACE"]))
			primary = true;
		if (FlxG.keys.anyPressed(["SHIFT"]))
			secondary = true;
	}
}