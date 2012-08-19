package attacks {
	import db.dbData.AttackData;
	
	/**
	 * An attack which is cast on a circular shaped space.
	 */
	public class AttackPoint extends AttackData implements Attack {
		/** radius of the attack area */
		public var radius:int;
		
		override public function parseData(obj:Object):void {
			super.parseData(obj);
			
			radius = obj.radius;
		}
	}
}