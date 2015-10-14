package;

class PersistentData
{
	// Remember and restore stats and unlocks
	public var playerHearts:Int;
	public var playerResidualMax:Float;
	public var playerCurrentResidual:Float;
	public var playerRegen:Float;
	
	public var shotgunLocked:Bool;
	public var sniperLocked:Bool;
	public var rocketLauncherLocked:Bool;
	public var laserLocked:Bool;
	public var machineGunLocked:Bool;
	public var crowdLaserLocked:Bool;
	public var preciseLaserLocked:Bool;
	
	public function new()
	{
	}
	
	public function save(state:PlayState)
	{
		playerHearts = state.player.stats.hearts;
		playerResidualMax = state.player.stats.residualMax;
		playerCurrentResidual = state.player.stats.residualCurrent;
		playerRegen = state.player.stats.regen;
		
		shotgunLocked = state.player.shotgun.locked;
		sniperLocked = state.player.sniper.locked;
		rocketLauncherLocked = state.player.rocketLauncher.locked;
		laserLocked = state.player.laser.locked;
		machineGunLocked = state.player.machineGun.locked;
		crowdLaserLocked = state.player.crowdLaser.locked;
		preciseLaserLocked = state.player.preciseLaser.locked;
	}
	
	public function restore(state:PlayState)
	{
		state.player.stats.hearts = playerHearts;
		state.player.stats.residualMax = playerResidualMax;
		state.player.stats.residualCurrent = playerCurrentResidual;
		state.player.stats.regen = playerRegen;
		
		state.player.shotgun.locked = shotgunLocked;
		state.player.sniper.locked = sniperLocked;
		state.player.rocketLauncher.locked = rocketLauncherLocked;
		state.player.laser.locked = laserLocked;
		state.player.machineGun.locked = machineGunLocked;
		state.player.crowdLaser.locked = crowdLaserLocked;
		state.player.preciseLaser.locked = preciseLaserLocked;
	}
}