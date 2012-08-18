package attacks {
	import db.dbData.AttackData;
	
	/**
	 * An attack which is cast on a circular shaped space.
	 */
	public class AttackPoint extends AttackData implements Attack {
		/** radius of the attack area */
		public var radius:int;
		
		public static function parseData(obj:Object):DatabaseData {
			var atk:DatabaseData = new AttackDashSkillshot();
			populateDate(atk, obj);
			
			return atk;
		}
		
		override public function populateData(dbData:DatabaseData, obj:Object):void {
			super.populateData(dbData, obj);
			
			var atk:AttackPoint = (dbData as AttackPoint);
			atk.radius = obj.radius;
		}
	}
}