package attacks {
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Point;
	
	import db.dbData.AttackData;
	
	import game.Game;
	
	import units.StatUnit;
	
	import util.Vector2D;
	
	/**
	 * A skillshot attack which is cast in a line
	 * Range is used as the end destination of projectiles
	 */
	public class AttackLaser extends AttackSkillshot {
		
		override public function parseData(obj:Object):void {
			super.parseData(obj);
		}
		
		override public function showGuide(caster:StatUnit, castPoint:Point):void{
			super.showGuide(caster, castPoint);
		}
		
		override public function shootSkillshot(bullets:Array):void {
			// get constructor and delete template
			
			var b:MovieClip = bullets[0];
			var projClass:Class = b.constructor;
			var bp = b.parent.height;
			b.parent.removeChild(b); 
			
			for (var i:int = 0; i < quantity; i++) {
				var p:MovieClip = new projClass();
				p.x = m_caster.x;
				p.x += (m_caster.scaleX > 0) ? b.x : -b.x;
				p.y = m_caster.y + b.y; // - bp/2
				//get correct orientation
				p.rotation = Math.atan2(m_castPoint.y - m_caster.y, m_castPoint.x - m_caster.x) * 180 / Math.PI - 90;
				p.scaleX = (m_caster.scaleX > 0) ? 1 : -1;
				
				p.addEventListener(Event.ENTER_FRAME, projectileRunner);
				p.m_penetrates = penetrates;
				Game.world.addUnit(p);
				
				m_bullets.push(p);
			}
		}	
		
		override protected function projectileRunner(e:Event):void {
			var p:MovieClip = e.target as MovieClip;
			if(p.currentFrame == p.framesLoaded) {
				removeProjectile(p);				
			}
		}
		
		override public function dealDamage():void {
			var targets:Array = targets();
			
			for (var i:String in targets) {
				var e:StatUnit = targets[i];
				
				var center = new Vector2D(e.x, e.y);
				var source = new Vector2D(m_caster.x, m_caster.y);
				
				var dir = new Vector2D(m_castPoint.x - m_caster.x, m_castPoint.y - m_caster.y);
				dir = dir.normalize();
				var dist = center.dist(source);
				var p = center.projectOntoLine(source, new Vector2D(source.x + dir.x * dist,
																	    source.y + dir.y * dist));

				if(center.dist(p) <= width && source.dist(p) < range) {
					dealTargetDamage(e);
				}
			}
		}
		
		override public function getAttackType():String {
			return "Laser - FIRE THAT SHIT";
		}
		
	}
}