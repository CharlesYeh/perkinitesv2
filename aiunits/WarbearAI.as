package aiunits {
	import flash.net.URLRequest;
	import flash.events.Event;
	import db.EnemyDatabase;
	import db.AbilityDatabase;
	import units.*;
	import flash.geom.Point;
	import db.dbData.EnemyData;
	
	import game.Game;
	
	/* MINIBOSS WARBEAR AI
	 * if within chase range, chases
	 * if within ability range, uses ability
	 */
	public class WarbearAI extends AIUnit {
		public function WarbearAI(edat:EnemyData) {
			super(edat);
		}
		
		// just moves to player if player is in range then attack
		override protected function runnerAI(e:Event) {
			if (!m_enabled) {
				return;
			}
			
			if (progressData.health <= 0) 
				Game.world.clearEnemy(this);
			
			var atkRange = unitData.abilities[0].range;
			
			var target:StatUnit = getCloserPlayer();
			var tp:Point = new Point(target.x, target.y);
			
			var dist:Number = getDistance(target);
			if (dist < atkRange) {
				// attack
				castAbility(0, tp);
			}
			else {
				chaseTarget(target, 250);
			}
		}
	}
}