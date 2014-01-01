package attacks {
	import db.dbData.AttackData;
	import units.StatUnit;
	import flash.geom.Point;
	import game.Game;
	import game.SoundManager;
	import units.AIUnit;
	
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
			caster.guide.visible = true;
			// set range guide
			caster.guide.range_circle.width = caster.guide.range_circle.height =
							2 * range;
			caster.guide.gotoAndStop("smartcast");
		}
		
		/**
		 * casts the ability at castPoint
		 */
		override public function castAbility(caster:StatUnit, castPoint:Point):void {
			super.castAbility(caster, castPoint);
		}
		
		override public function dealDamage():void {
			var targets:Array = targets();
			for (var i:String in targets) {
				
				var e:StatUnit = targets[i];
				
				if (StatUnit.distance(m_caster, e) < range) {
					dealTargetDamage(e);
/*						if(AIUnit.m_enabled){
							SoundManager.playSound("hit");
						}		*/				
				}
			}
		}
		
		override public function getAttackType():String {
			return "Point Blank - This attack affects enemies within" + range + "units from this Perkinite."
		}
	}
}