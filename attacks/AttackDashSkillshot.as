package attacks {
	import db.dbData.AttackData;
	import units.StatUnit;
	import flash.geom.Point;
	
	/**
	 * A skillshot attack which is cast in a line
	 * Range is used as the end destination of projectiles
	 */
	public class AttackDashSkillshot extends AttackSkillshot {
		/** whether to stop movement at the first enemy hit */
		public var stopAtEnemy:Boolean;
		
		/** whether this */
		public var m_moveForward:Boolean = false;
		
		override public function parseData(obj:Object):void {
			super.parseData(obj);
			
			stopAtEnemy = obj.stopAtEnemy;
		}
		
		override public function showGuide(caster:StatUnit, castPoint:Point):void{
			super.showGuide(caster, castPoint);
			
			var horizmult:int = (caster.scaleX > 0) ? 1 : -1;			
			caster.guide.gotoAndStop("skillshot");
			trace("okay");
			var dx = castPoint.x - caster.x;
			var dy = castPoint.y - caster.y;
			var dist = Math.sqrt(dx * dx + dy * dy);
			caster.guide.guide_skillshot.rotation = 0;
			caster.guide.guide_skillshot.width = Math.min(range, dist);
			caster.guide.guide_skillshot.rotation = Math.atan2(caster.y - castPoint.y, horizmult * (caster.x - castPoint.x)) * 180 / Math.PI + 180;
		}
	}
}