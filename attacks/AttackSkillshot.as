package attacks {
	import db.dbData.AttackData;
	
	/**
	 * A skillshot attack which is cast in a line
	 * Range is used as the end destination of projectiles
	 */
	public class AttackSkillshot extends Attack {
		/** the width of the projectile */
		public var width:int;
		
		/** # of enemies this attack will penetrate */
		/** 0 means the projectile is discarded after a single hit */
		public var penetrates:int;
		
		/** travel speed of projectile */
		public var speed:int;
		
		override public function parseData(obj:Object):void {
			super.parseData(obj);
			
			width	= obj.width;
			penetrates	= obj.penetrates;
			speed	= obj.speed;
		}
	}
}