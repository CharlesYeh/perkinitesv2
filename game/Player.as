package game{
	
	public class Player {
		private static const PLAYER_HEAL_TIMELAPSE:int = 24;
		
		private static var HEAL_PERCENTAGE:Number = .02;
		private static var PLAYER_HEAL_DELAY:int = 120;
		private static var playerHealDelay:int = 0;

		private static var prevHealth:int = -1;

		public static function updateHealing():void {
			if (Game.playerProgress.health <= 0) {
				playerHealDelay = PLAYER_HEAL_DELAY;
				return;
			}
			//i think this works now
			if (prevHealth == -1) {
				// init previous healths
				prevHealth = Game.playerProgress.health;
				playerHealDelay = 0;
			} else {
				if (prevHealth > Game.playerProgress.health) {
					playerHealDelay = PLAYER_HEAL_DELAY;
				} else {
					playerHealDelay--;
				}
			}

			// heal
			if (playerHealDelay <= 0 && playerHealDelay % PLAYER_HEAL_TIMELAPSE == 0) {
				// add % of max hp
				var mhp:int = Game.playerProgress.getMaxHealth();
				var dhp:int = mhp * HEAL_PERCENTAGE;
				dhp = Math.min(mhp - Game.playerProgress.health, dhp);

				Game.playerProgress.takeDamage(-dhp);
			}
			prevHealth = Game.playerProgress.health;
		}
	}
}