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
		public function showGuide(caster:StatUnit, castPoint:Point):void {
		}
		
		/**
		 * shows the guide aiming at castPoint
		 */
		public function updateGuide(caster:StatUnit, castPoint:Point):void {
			showGuide(caster, castPoint);
		}
				
		
		/**
		 * casts the ability at castPoint
		 */
		public function castAbility(caster:StatUnit, castPoint:Point):void {}
		
		/**
		 * updates the ability as its animation is playing
		 */
		public function castInProgress(caster:StatUnit):void {}
		
		//--------------FRAME FUNCTIONS----------------
		
		public function endAbility():void {}
		public function beginForwardMovement():void {}
		public function stopForwardMovement():void {}
		public function dealDamage():void {}
		public function applyBuffs():void {}
		public function shootSkillshot():void {}
		public function teleport():void {}
		public function teleportPartner():void {}
	}
}