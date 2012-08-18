package attacks {
	import db.dbData.AttackData;
	
	/**
	 * A skillshot attack which is cast in a line
	 * Range is used as the end destination of projectiles
	 */
	public class AttackDashSkillshot extends AttackSkillshot implements Attack {
		/** whether to stop movement at the first enemy hit */
		public var stopAtEnemy:Boolean;
		
		public static function parseData(obj:Object):DatabaseData {
			var atk:DatabaseData = new AttackDashSkillshot();
			populateDate(atk, obj);
			
			return atk;
		}
		
		override public function populateData(dbData:DatabaseData, obj:Object):void {
			super.populateData(dbData, obj);
			
			var atk:AttackDashSkillshot = dbData as AttackDashSkillshot;
			atk.stopAtEnemy = obj.stopAtEnemy;
		}
	}
}