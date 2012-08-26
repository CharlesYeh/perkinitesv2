package aiunits {
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
			//super(EnemyDatabase.ENEMY_ID_START + id);
		}
		
		// just moves to player if player is in range then attack
		override protected function runnerAI(e:Event) {
			if (progressData.health <= 0) //is this the right health to use?
				deleteSelf();
			
			var atkRange = unitData.abilities[0].range;//AbilityDatabase.getAttribute(ID, 0, "Range");
			
			var target:StatUnit = getCloserPlayer();
			var tp:Point = new Point(target.x, target.y);
			
			var dist:Number = getDistance(target);
			if (dist < atkRange) {
				// attack
				//castMousePoint	= new Point(target.x, target.y);
				//castMouseTarget	= target;
				
				castAbility(0, tp);
				/*if (AbilityDatabase.getTargetType(ID, 0) != AbilityDatabase.ATKTYPE_SCAST) {
					clickHandler(tp, target);
				}*/
			}
			else {
				chaseTarget(target, 250);
			}
		}
	}
}