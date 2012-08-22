package attacks {
	import db.dbData.AttackData;
	
	/**
	 * An attack which is cast on a cone shaped space.
	 * Range is used for the length/height of the cone.
	 */
	public class AttackCone extends Attack {
		/** the width of the cone in radians */
		public var angle:Number;
		
		override public function parseData(obj:Object):void {
			super.parseData(obj);
			angle = obj.angle;
		}
	}
}