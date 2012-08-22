package attacks {
	import flash.geom.Point;
	
	import units.StatUnit;
	
	import db.dbData.AttackData;

	public class Attack extends AttackData {
		/**
		 * returns whether or not the caster can cast to this point
		 */
		public function inRange(caster:StatUnit, castPoint:Point):Boolean {
			return true;
		}
		
		/**
		 * shows the guide aiming at castPoint
		 */
		public function showGuide(caster:StatUnit, castPoint:Point):void {}
		
		/**
		 * casts the ability at castPoint
		 */
		public function castAbility(cast:StatUnit, castPoint:Point):void {}
	}
}