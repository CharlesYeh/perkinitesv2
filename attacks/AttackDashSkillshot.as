package attacks {
	import db.dbData.AttackData;
	
	/**
	 * A skillshot attack which is cast in a line
	 * Range is used as the end destination of projectiles
	 */
	public class AttackDashSkillshot extends AttackSkillshot implements Attack {
		/** whether to stop movement at the first enemy hit */
		public var stopAtEnemy:Boolean;
		
		override public function parseData(obj:Object):void {
			super.parseData(obj);
			
			stopAtEnemy = obj.stopAtEnemy;
		}
	}
}