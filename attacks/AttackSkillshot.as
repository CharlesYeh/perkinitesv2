package attacks {
	import db.dbData.AttackData;
	
	import units.StatUnit;
	
	import flash.geom.Point;
	import flash.display.MovieClip;
	
	import flash.events.Event;
	
	import game.Game;
	
	/**
	 * A skillshot attack which is cast in a line
	 * Range is used as the end destination of projectiles
	 */
	public class AttackSkillshot extends Attack {
		/** number of projectiles to multiply each firing by */
		public var quantity:int;
		
		/** the width of the projectile */
		public var width:int;
		
		/** # of enemies this attack will penetrate */
		/** 0 means the projectile is discarded after a single hit */
		public var penetrates:int;
		
		/** travel speed of projectile */
		public var speed:int;
		
		/** the projectile MCs themselves */
		protected var m_bullets:Array;
		
		protected var m_penetrates:int;
		
		override public function parseData(obj:Object):void {
			super.parseData(obj);
			
			quantity	= (obj.quantity) ? obj.quantity : 1;
			width		= obj.width;
			penetrates	= obj.penetrates;
			speed		= obj.speed;
		}
		
		override public function castAbility(caster:StatUnit, castPoint:Point):void {
			super.castAbility(caster, castPoint);
			
			// if bullets still exist from before, remove them
			if (m_bullets != null) {
				for (var i:String in m_bullets) {
					var p:MovieClip = m_bullets[i];
					
					p.removeEventListener(Event.ENTER_FRAME, projectileRunner);
					Game.world.removeUnit(p);
				}
			}
			m_bullets = new Array();
			
			m_penetrates = penetrates;
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
			//caster.guide.guide_skillshot.width = Math.min(range, dist);
			caster.guide.guide_skillshot.rotation = Math.atan2(caster.y - castPoint.y, horizmult * (caster.x - castPoint.x)) * 180 / Math.PI + 180;
		}
		
		override public function shootSkillshot(bullets:Array):void {
			// get constructor and delete template
			var b:MovieClip = bullets[0];
			var projClass:Class = b.constructor;
			b.parent.removeChild(b);
			
			for (var i:int = 0; i < quantity; i++) {
				var p:MovieClip = new projClass();
				p.x = m_caster.x;
				p.y = m_caster.y;
				
				prepareProjectile(p, Number(i) / quantity);
				
				p.addEventListener(Event.ENTER_FRAME, projectileRunner);
				Game.world.addUnit(p);
				
				m_bullets.push(p);
			}
		}
		
		/**
		 * custom prepare a projectile
		 *
		 * @param	ratio	index / total projectiles of this specific projectile
		 */
		protected function prepareProjectile(p:MovieClip, ratio:Number):void {
			var dx:Number = m_castPoint.x - p.x;
			var dy:Number = m_castPoint.y - p.y;
			var dist:Number = Math.sqrt(dx * dx + dy * dy);
			
			p.vx = speed * dx / dist;
			p.vy = speed * dy / dist;
		}
		
		/**
		 * enter frame handler for projectiles
		 */
		protected function projectileRunner(e:Event):void {
			var p:MovieClip = e.target as MovieClip;
			
			p.x += p.vx;
			p.y += p.vy;
			
			p.dist += speed;
			
			testSkillshotCollision(p);
			
			if (p.dist > range) {
				removeProjectile(p);
			}
		}
		
		protected function testSkillshotCollision(skillshot:MovieClip):Boolean {
			var targets:Array = targets();
			var hit:Boolean = false;
			
			for (var a:String in targets) {
				var en:StatUnit = targets[a];
				
				if (StatUnit.distance(en, skillshot) < width) {
					en.takeDamage(damage());
					
					// TODO: find actual closest to old position?
					
					// TODO: penetrate select amount
					if (m_penetrates == 0) {
						return true;
					}
					else {
						m_penetrates--;
						hit = true;
					}
				}
			}
			
			return hit;
		}
		
		protected function removeProjectile(p:MovieClip):void {
			m_bullets.splice(m_bullets.indexOf(p), 1);
			p.removeEventListener(Event.ENTER_FRAME, projectileRunner);
			Game.world.removeUnit(p);
		}
	}
}