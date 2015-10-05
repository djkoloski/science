package;

import flixel.FlxG;

class InputController
{
	public FlxVector movement;
	public Bool primary;
	public Bool secondary;

	public void update()
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