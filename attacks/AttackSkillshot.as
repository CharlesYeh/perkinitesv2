package attacks {
	import db.dbData.AttackData;
	
	import units.StatUnit;
	
	import flash.geom.Point;
	import flash.display.MovieClip;
	
	import flash.events.Event;
	
	import game.Game;
	import flash.utils.Dictionary;
	
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
		
		//prevent a skillshot from hitting the same enemy multiple times
		protected var hits:Array;
		
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
					Game.world.clearCustom(p);
				}
			}
			hits = new Array();
			
			m_bullets = new Array();
			m_penetrates = penetrates;
		}
	
		override public function showGuide(caster:StatUnit, castPoint:Point):void{
			caster.guide.visible = true;
			// set range guide
			caster.guide.range_circle.width = caster.guide.range_circle.height = 2 * range;
			
			var horizmult:int = (caster.scaleX > 0) ? 1 : -1;			
			caster.guide.gotoAndStop("skillshot");
			var dx = castPoint.x - caster.x;
			var dy = castPoint.y - caster.y;
			var dist = Math.sqrt(dx * dx + dy * dy);
			
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
				//get correct orientation
				p.rotation = b.rotation;
				p.scaleX = (m_caster.scaleX > 0) ? 1 : -1;			
				
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
			p.dist = 0; //make skillshot show up
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
			
			if (p.dist > range || m_penetrates < 0) {
				removeProjectile(p);
			}
		}
		
		protected function testSkillshotCollision(skillshot:MovieClip):Boolean {
			var targets:Array = targets();
			var hit:Boolean = false;
			
			var closest:Dictionary = new Dictionary();
			var distances:Array = new Array();
			
			for (var a:String in targets) {
				var en:StatUnit = targets[a];
				
				var dist:Number = StatUnit.distance(en, skillshot);
				
				if (dist < width) {
					//prevent multiple hits on the same enemy
					if(hits.indexOf(en) == -1){
						hits.push(en);
						
						// find actual closest to old position?
						if (en != null) {
							closest[dist] = en;
							distances.push(dist);
						}
						
						hit = true;
					}
				}
			}
			
			// check collisions for closest
			if (hit) {
			 	var n:int = 0;
				for (var key:* in closest) {
					n++;
				}
				//what does this if statement do? explain to me later prease :D
				if (m_penetrates == 1) {
					//length on dictionary doesn't exist
					if (n != 0) {
						var keys:Array = distances.sort();
						en = closest[0];
						en.takeDamage(damage());
						
						//removeProjectile(skillshot);
					}
					
					m_penetrates--;
				}
				else {
					// damage all closest units
					for (var i:String in closest) {
						en = closest[i];
						en.takeDamage(damage());
						
						m_penetrates--;
					}
				}
				
			}
			
			return hit;
		}
		
		protected function removeProjectile(p:MovieClip):void {
			m_bullets.splice(m_bullets.indexOf(p), 1);
			p.removeEventListener(Event.ENTER_FRAME, projectileRunner);
			Game.world.clearCustom(p);
		}
		
		//making a public function?
		public function destroyProjectile(p:MovieClip):void{
			removeProjectile(p);
		}
	}
}