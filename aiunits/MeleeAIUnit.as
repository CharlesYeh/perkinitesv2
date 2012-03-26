package aiunits {
	import flash.net.URLRequest;
	import flash.events.Event;
	import db.EnemyDatabase;
	import game.*;
	
	/* BASIC AI ENEMY
	 * if within chase range, chases
	 * if within ability range, uses ability
	 */
	public class BasicAIUnit extends AIUnit {
		public function MeleeAIUnit(id) {
			super(id);
		}
		
		// just moves to player if player is in range then attack
		override function runnerAI(e:Event) {
			/*range = 250;
			
			// if close to player
			var min:GameUnit;
			var minDist:Number = 99999999;
			
			for (var i in targets) {
				var un:GameUnit = targets[i];
				var dx = un.x - x;
				var dy = un.y - y;
				var d = dx * dx + dy * dy;
				
				if (d < minDist) {
					min = un;
					minDist = d;
				}
			}
			
			if (minDist < range * range) {
				moveTo(min.x, min.y);
			}*/
		}
	}
}