package attacks {
	import db.dbData.AttackData;
	
	/**
	 * An attack which is cast on a cone shaped space.
	 * Range is used for the length/height of the cone.
	 */
	public class AttackCone extends AttackData implements Attack {
		/** the width of the cone in radians */
		public var radius:Number;
		
		public static function parseData(obj:Object):DatabaseData {
			var atk:DatabaseData = new AttackCone();
			populateDate(atk, obj);
			
			return atk;
		}
		
		override public function populateData(dbData:DatabaseData, obj:Object):void {
			super.populateData(dbData, obj);
			
			var atk:AttackCone = (dbData as AttackCone);
			atk.radius = obj.radius;
		}
	}
}