package aiunits {
	import flash.net.URLRequest;
	import flash.events.Event;
	import db.EnemyDatabase;
	import db.AbilityDatabase;
	import game.*;
	import flash.geom.Point;
	
	/* BASIC AI ENEMY
	 * if within chase range, chases
	 * if within ability range, uses ability
	 */
	public class BasicAIUnit extends AIUnit {
		public function BasicAIUnit(id) {
			super(id);
		}
		
		// just moves to player if player is in range then attack
		override protected function runnerAI(e:Event) {
			var atkRange = AbilityDatabase.getAttribute(ID, 0, "range");
			
			var target:StatUnit = getCloserPlayer();
			var dist:Number = getDistance(target);
			
			if (dist < atkRange) {
				// attack
				castMousePoint	= new Point(target.x, target.y);
				castMouseTarget	= target;
				
				startCastAnimation();
			}
			else {
				chaseTarget(target, 250);
			}
		}
	}
}