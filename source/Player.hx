package;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.util.FlxColor;
import flixel.util.FlxAngle;


class Player extends FlxSprite
{
	private var state:PlayState;
	
	public var speed:Float;
	public var stats:Stats;
	public var weaponManager:WeaponManager;
	static public var firing:Bool = false;
	
	public function new(playState:PlayState)
	{
		super();
		makeGraphic(32, 32, FlxColor.BLUE);
		
		state = playState;
		speed = 200.0;
		stats = new Stats();
		weaponManager = new WeaponManager(playState, WeaponType_Bullet1);
		
		drag.x = drag.y = 1600.0;
	}
	
	private function updateMovement():Void
	{
		var dx:Float = 0;
		var dy:Float = 0;
		
		if (FlxG.keys.pressed.D)
		{
			dx += 1.0;
		}
		if (FlxG.keys.pressed.A)
		{
			dx -= 1.0;
		}
		if (FlxG.keys.pressed.S)
		{
			dy += 1.0;
		}
		if (FlxG.keys.pressed.W)
		{
			dy -= 1.0;
		}
		
		if (dx != 0 || dy != 0)
		{
			var len = Math.sqrt(dx * dx + dy * dy);
			velocity.x = dx * speed / len;
			velocity.y = dy * speed / len;
		}
		else
		{
			velocity.x = 0;
			velocity.y = 0;
		}
	}
	
	public function updateWeapon():Void
	{
		var dx:Float = 0.0;
		var dy:Float = 0.0;
		firing = false;
		
		if (FlxG.keys.pressed.RIGHT)
		{
			dx += 1.0;
		}
		if (FlxG.keys.pressed.LEFT)
		{
			dx -= 1.0;
		}
		if (FlxG.keys.pressed.DOWN)
		{
			dy += 1.0;
		}
		if (FlxG.keys.pressed.UP)
		{
			dy -= 1.0;
		}
		
		var len:Float = Math.sqrt(dx * dx + dy * dy);
		if (len != 0)
		{
			dx /= len;
			dy /= len;
		}
		var fireAngle:Float = Math.atan2(dy, dx);
		
		var weaponSwap: Bool = FlxG.keys.justPressed.Q;
		var meleeSwap:Bool = FlxG.keys.justPressed.SHIFT;
		
		var weaponX:Float = x + width / 2.0 + dx * width / 2.0;
		var weaponY:Float = y + height / 2.0 + dy * height / 2.0;
		
		if (weaponSwap)
		{
			switch (weaponManager.type)
			{
				case WeaponType_Bullet1:
					weaponManager.setType(WeaponType_Bullet2);
				case WeaponType_Bullet2:
					weaponManager.setType(WeaponType_Bullet3);
				case WeaponType_Bullet3:
					weaponManager.setType(WeaponType_Bullet1);
				default:
					throw "Unknown weapon type";
			}
		}
		
		if (meleeSwap)
		{
			if (weaponManager.type == WeaponType_Melee)
			{
				weaponManager.setType(WeaponType_Bullet1);
			}
			else
			{
				weaponManager.setType(WeaponType_Melee);
			}
		}
		
		if (dx != 0 || dy != 0)
		{
			trace("Firing");
			weaponManager.fire(
				weaponX,
				weaponY,
				fireAngle
			);
		}
		
		weaponManager.update();
	}
	
	public override function update():Void
	{
		super.update();
		updateMovement();
		updateWeapon();
		
		stats.update();
	}
}
