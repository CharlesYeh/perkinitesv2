package attacks {
	import db.dbData.AttackData;
	import units.StatUnit;
	import flash.geom.Point;
	
	/**
	 * A skillshot attack which is cast in a line
	 * Range is used as the end destination of projectiles
	 */
	public class AttackDashSkillshot extends AttackSkillshot {
		
		/** whether this */
		public var m_moveForward:Boolean = false;
		public var m_forwardVector:Point;
		
		override public function parseData(obj:Object):void {
			super.parseData(obj);
		}
		
		override public function showGuide(caster:StatUnit, castPoint:Point):void{
			caster.guide.visible = true;
			// set range guide
			caster.guide.range_circle.width = caster.guide.range_circle.height =
							2 * range;
			
			var horizmult:int = (caster.scaleX > 0) ? 1 : -1;			
			caster.guide.gotoAndStop("skillshot");
			
			var dx = castPoint.x - caster.x;
			var dy = castPoint.y - caster.y;
			var dist = Math.sqrt(dx * dx + dy * dy);
			
			caster.guide.guide_skillshot.rotation = 0;
			caster.guide.guide_skillshot.rotation = Math.atan2(caster.y - castPoint.y,  horizmult*(caster.x - castPoint.x)) * 180 / Math.PI + 180;
		}
		
		override public function castAbility(caster:StatUnit, castPoint:Point):void {
			super.castAbility(caster, castPoint);
			
			m_moveForward = false;
			
			var dx:Number = castPoint.x - caster.x;
			var dy:Number = castPoint.y - caster.y;
			var d:Number = Math.sqrt(dx * dx + dy * dy);
			dx = dx / d;
			dy = dy / d;
			
			m_forwardVector = new Point(dx * speed, dy * speed);
		}
		
		override public function castInProgress(caster:StatUnit):void {
			super.castInProgress(caster);
			
			if (m_moveForward) {
				// move forward!!
				caster.teleportTo(caster.x + m_forwardVector.x, caster.y + m_forwardVector.y);
				caster.clearPath();
				
				// caster is the skillshot projectile
				if (testSkillshotCollision(caster)) {
					// stop dashing and ability
					caster.stopForwardMovement();
					caster.enableMovement();
					caster.endAbility();
				}
			}
		}
		
		override public function beginForwardMovement():void {
			m_moveForward = true;
		}
		
		override public function stopForwardMovement():void {
			m_moveForward = false;
		}
	}
}