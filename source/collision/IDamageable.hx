package collision;
import flixel.util.FlxPoint;

interface IDamageable
{
	public function getDamageableMask():Int;
	public function receiveDamage(damage:Int, source:Int):Void;
	public function stun(velocity:FlxPoint):Void;
}