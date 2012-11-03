package game {
	import units.Perkinite;
	
	public class Player {
		
		public static const HEAL_PERCENTAGE:Number = .02;
		public static const PLAYER_HEAL_DELAY:int = 80;
		public static var playerHealDelay:int = 0;
		
		private static var prevHealth:Array = new Array();
		
		public function updateHealing(team:Array):void {
			if (prevHealth.length != team.length) {
				// init previous healths
				for (var i = 0; i < team.length; i++) {
					var p:Perkinite = team[i];
					prevHealth[i] = p.progressData.health;
				}
				
				playerHealDelay = 0;
			}
			else {
				var damaged:Boolean = false;
				// check if any hps changed
				for (i = 0; i < prevHealth.length; i++) {
					p = team[i];
					
					if (p.progressData.health != prevHealth[i]) {
						damaged = true;
						break;
					}
				}
				
				if (damaged) {
					playerHealDelay = 0;
					for (i = 0; i < prevHealth.length; i++) {
						prevHealth[i] = team[i].progressData.health;
					}
				}
				else {
					playerHealDelay++;
				}
			}
			
			// heal
			if (playerHealDelay > PLAYER_HEAL_DELAY) {
				for (i = 0; i < team.length; i++) {
					p = team[i];
					
					// add % of max hp
					var mhp:int = p.unitData.health;
					var dhp:int = mhp * HEAL_PERCENTAGE;
					dhp = Math.min(mhp - p.progressData.health, dhp);
					
					p.takeDamage(-dhp);
				}
			}
		}
	}
	
}
