package attacks {
	import db.dbData.AttackData;
	import units.StatUnit;
	import flash.geom.Point;
	
	/**
	 * projectiles appear around the caster which home-in on nearby targets
	 */
	public class AttackHomingProjectiles extends Attack {
		/** the width of the cone in radians */
		public var quantity:int;
		
		/** once a target is chosen, whether the projectile will only hit */
		/** the chosen target or if it'll collide with other enemies first */
		public var hardTarget:Boolean = true;
		
		override public function parseData(obj:Object):void {
			super.parseData(obj);
			
			quantity = obj.quantity;
			hardTarget = obj.hardTarget;
		}
		
		override public function showGuide(caster:StatUnit, castPoint:Point):void {
			super.showGuide(caster, castPoint);
		}
	}
}