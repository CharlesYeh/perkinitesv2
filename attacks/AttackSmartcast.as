﻿package attacks {
	import db.dbData.AttackData;
	import units.StatUnit;
	import flash.geom.Point;
	
	/**
	 * An attack which is cast on a circular shaped space.
	 */
	public class AttackSmartcast extends Attack {
		
		public var goToCastPoint:Boolean = false;
		
		override public function parseData(obj:Object):void {
			super.parseData(obj);
			
			goToCastPoint = obj.goToCastPoint;
		}
		
		/**
		 * shows the guide aiming at castPoint
		 */
		override public function showGuide(caster:StatUnit, castPoint:Point):void {
			super.showGuide(caster, castPoint);
			caster.guide.gotoAndStop("smartcast");
		}
		
		/**
		 * casts the ability at castPoint
		 */
		override public function castAbility(cast:StatUnit, castPoint:Point):void {
			
		}
	}
}