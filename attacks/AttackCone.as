package attacks {
	import db.dbData.AttackData;
	import units.AIUnit;
	import units.StatUnit;
	import game.Game;
	import flash.geom.Point;
	import game.SoundManager;
	
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
			caster.guide.guide_cone.width = range;
			if(angle == 90){
				angle = 45;
			}
			caster.guide.guide_cone.height = Math.tan(angle * Math.PI/180)*range;
			caster.guide.guide_cone.rotation = Math.atan2(caster.y - castPoint.y, horizmult * (caster.x - castPoint.x)) * 180 / Math.PI + 180;			
		}
		
		override public function dealDamage():void {
			var targets:Array = targets();
			
			// TODO: calculate cone
			for (var i:String in targets) {
				var e:StatUnit = targets[i];
				
				if (StatUnit.distance(m_caster, e) < range) {
					var u:Point =  new Point(m_caster.castPoint.x - m_caster.x, m_caster.castPoint.y - m_caster.y);
					var v:Point = new Point(e.x - m_caster.x, e.y - m_caster.y); 
					
					var arg:Number = (u.x * v.x + u.y * v.y)/(u.length*v.length);
					if(arg > 1){
						arg = 1;
					}
					else if(arg < -1){
						arg = -1;
					}
					if(Math.acos(arg) * 180 / Math.PI<= angle){
						e.takeDamage(damage());				
						
/*						if(AIUnit.m_enabled){
							SoundManager.playSound("hit");
						}		*/
						
/*						if(AIUnit.m_enabled){
							var mtv = new Point(m_caster.x - e.x, m_caster.y - e.y);
							//try to make it so that it doesn't knockback into an impassable tile
							mtv.normalize(knockback);
							e.x -= mtv.x;
							e.y -= mtv.y;							
						}*/
						
						//if it hits the lead Perkinite, do not hit the partner Perkinite
						if(e == Game.team[0]){
							break;
						}
					}
				}
			}
		}
	}
}