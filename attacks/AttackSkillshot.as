package attacks {
	import db.dbData.AttackData;
	
	/**
	 * A skillshot attack which is cast in a line
	 * Range is used as the end destination of projectiles
	 */
	public class AttackSkillshot extends AttackData implements Attack {
		/** the width of the projectile */
		public var width:int;
		
		/** # of enemies this attack will penetrate */
		/** 0 means the projectile is discarded after a single hit */
		public var penetrates:int;
		
		/** travel speed of projectile */
		public var speed:int;
		
		public static function parseData(obj:Object):DatabaseData {
			var atk:DatabaseData = new AttackSkillshot();
			
			return atk;
		}
		
		override public function populateData(dbData:DatabaseData, obj:Object):void {
			super.populateData(dbData, obj);
			
			var atk:AttackCone = (dbData as AttackCone);
			atk.radius = obj.radius;
		}
	}
}