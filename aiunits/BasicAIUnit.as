package aiunits {
	import game.Game;
	import flash.net.URLRequest;
	import flash.events.Event;
	import db.EnemyDatabase;
	import db.AbilityDatabase;
	import units.*;
	import flash.geom.Point;
	import db.dbData.EnemyData;
	
	/* BASIC AI ENEMY
	 * if within chase range, chases
	 * if within ability range, uses ability
	 */
	public class BasicAIUnit extends AIUnit {
		public function BasicAIUnit(edat:EnemyData) {
			super(edat);
			cooldowns[0] = 0; //temporary 
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
				if(cooldowns[0] <= 0){
					castAbility(0, tp);
				}
				else{
					path = new Array();
				}
			}
			else {
				chaseTarget(target, 250);
			}
		}
	}
}