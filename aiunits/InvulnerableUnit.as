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
	public class InvulnerableUnit extends BasicAIUnit {
		
		public function InvulnerableUnit(edat:EnemyData) {
			super(edat);
			healthbar.visible = false;
		}
		
		override public function takeDamage(dmg:int):void {
			return;
		}
		
		override protected function runnerAI(e:Event) {
			
		}
		
	}
}