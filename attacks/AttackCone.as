package attacks {
	import db.dbData.AttackData;
	import units.StatUnit;
	import flash.geom.Point;
	
	/**
	 * An attack which is cast on a cone shaped space.
	 * Range is used for the length/height of the cone.
	 */
	public class AttackCone extends Attack {
		/** the width of the cone in radians */
		public var angle:int;
		
		override public function parseData(obj:Object):void {
			super.parseData(obj);
			angle = obj.angle;
		}
		
		override public function showGuide(caster:StatUnit, castPoint:Point):void {
			caster.guide.visible = true;
			// set range guide
			caster.guide.range_circle.width = caster.guide.range_circle.height =
							2 * range;
			
			var horizmult:int = (caster.scaleX > 0) ? 1 : -1;			
			caster.guide.gotoAndStop("cone");
			caster.guide.guide_cone.rotation = 0;
			caster.guide.guide_skillshot.width = range;
			caster.guide.guied_skillshot.height = Math.tan(angle)*range;
			caster.guide.guide_cone.rotation = Math.atan2(caster.y - castPoint.y, horizmult * (caster.x - castPoint.x)) * 180 / Math.PI + 180;			
			
			/*var ability = 
			
			var rad;

			caster.guide.visible = true;

				switch(ability.type){
					case "AttackSkillshot": 
						//120,30.20
						break;
					case "AttackPoint":	

						break;
					case "AttackDashSkillshot":
						caster.guide.gotoAndStop("skillshot");
						caster.guide.guide_skillshot.rotation = 0;
						dist = Math.sqrt(dx * dx + dy * dy);
						caster.guide.guide_skillshot.width = Math.min(ability.range, dist);
						caster.guide.guide_skillshot.rotation = Math.atan2(caster.y - castPoint.y, horizmult * (caster.x - castPoint.x)) * 180 / Math.PI + 180;
						break;
					case "AttackCone":
						break;
					case "AttackSmartcast":
						caster.guide.gotoAndStop("smartcast");
						break;
					}			*/
			
		}
	}
}