package attacks {
	import db.dbData.AttackData;
	
	import units.AIUnit;
	import units.StatUnit;
	
	import flash.geom.Point;
	import flash.display.MovieClip;
	
	import flash.events.Event;
	
	import game.Game;
	import game.SoundManager;
	import flash.utils.Dictionary;
	
	/**
	 * TypeError: Error #1009: Cannot access a property or method of a null object reference.
	 * at enemy_Ira_fla::ability3copy2_13/frame1()
	 * at flash.display::MovieClip/gotoAndStop()
	 * at attacks::AttackSkillshot/showGuide()
	 * at attacks::Attack/updateGuide()
	 * at units::StatUnit/showGuide()
	 * at game::Controls$/showGuides()
	 * at game::Controls$/handleGameInputs()
	 * at game::Game$/update()
	 * at perkinites_fla::MainTimeline/gameRunner()
	 */
	
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
			
			m_bullets = new Array();
		}
		
		override public function castAbility(caster:StatUnit, castPoint:Point):void {
			super.castAbility(caster, castPoint);
			
/*			// if bullets still exist from before, remove them
			if (m_bullets != null) {
				for (var i:String in m_bullets) {
					var p:MovieClip = m_bullets[i];
					
					p.removeEventListener(Event.ENTER_FRAME, projectileRunner);
					Game.world.clearCustom(p);
				}
			}*/
			hits = new Array();
			
			//m_bullets = new Array();
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
			var bp = b.parent.height;
			b.parent.removeChild(b); 
			
			for (var i:int = 0; i < quantity; i++) {
				var p:MovieClip = new projClass();
				p.x = m_caster.x;
				p.x += (m_caster.scaleX > 0) ? b.x : -b.x;
				p.y = m_caster.y + b.y; // - bp/2
				//trace(m_caster.y + " " + p.y);
				//get correct orientation
				p.rotation = b.rotation;
				p.scaleX = (m_caster.scaleX > 0) ? 1 : -1;			
				
				prepareProjectile(p, Number(i) / quantity);
				
				p.addEventListener(Event.ENTER_FRAME, projectileRunner);
				p.m_penetrates = penetrates;
				Game.world.addUnit(p);
				
				m_bullets.push(p);
			}
		}
		
		override public function shootDirectedSkillshot(bullets:Array, dir:Point, t:Number):void {
			// get constructor and delete template
			var b:MovieClip = bullets[0];
			var projClass:Class = b.constructor;
			var bp = b.parent.height;
			b.parent.removeChild(b); 
			
			for (var i:int = 0; i < quantity; i++) {
				var p:MovieClip = new projClass();
				p.x = m_caster.x + b.x;
				p.y = m_caster.y + b.y - bp/2;
				//get correct orientation
				p.rotation = b.rotation;
				p.scaleX = (m_caster.scaleX > 0) ? 1 : -1;			
				
				prepareDirectedProjectile(p, Number(i) / quantity, dir, t);
				
				p.addEventListener(Event.ENTER_FRAME, projectileRunner);
				p.m_penetrates = penetrates;
				Game.world.addUnit(p);
				
				m_bullets.push(p);
			}
		}
		
		override public function shootRelativeSkillshot(bullets:Array, angle:Number):void {
			// get constructor and delete template
			var b:MovieClip = bullets[0];
			var projClass:Class = b.constructor;
			var bp = b.parent.height;
			b.parent.removeChild(b); 
			
			for (var i:int = 0; i < quantity; i++) {
				var p:MovieClip = new projClass();
				p.x = m_caster.x;
				p.x += (m_caster.scaleX > 0) ? b.x : -b.x;
				p.y = m_caster.y + b.y - bp/2;
				//get correct orientation
				p.rotation = b.rotation;
				p.scaleX = (m_caster.scaleX > 0) ? 1 : -1;			
				
				var newX = p.x + (m_castPoint.x - p.x) * Math.cos(angle * Math.PI/180) - 
								(m_castPoint.y - p.y) * Math.sin(angle * Math.PI/180);
								
				var newY = p.y + (m_castPoint.x - p.x) * Math.sin(angle * Math.PI/180) +
								(m_castPoint.y - p.y) * Math.cos(angle * Math.PI/180);
								
				prepareRelativeProjectile(p, Number(i) / quantity, new Point(newX, newY));
				
				p.addEventListener(Event.ENTER_FRAME, projectileRunner);
				p.m_penetrates = penetrates;
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
		
		protected function prepareRelativeProjectile(p:MovieClip, ratio:Number, point:Point):void {
			var dx:Number = point.x - p.x;
			var dy:Number = point.y - p.y;
			var dist:Number = Math.sqrt(dx * dx + dy * dy);
			
			p.vx = speed * dx / dist;
			p.vy = speed * dy / dist;
			p.dist = 0; //make skillshot show up
		}
		
		protected function prepareDirectedProjectile(p:MovieClip, ratio:Number, dir:Point, t:Number):void {
			var castPoint:Point = new Point(p.x + dir.x * t, p.y + dir.y*t);
			
			var dx:Number = castPoint.x - p.x;
			var dy:Number = castPoint.y - p.y;
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
			
			if (p.dist > range || p.m_penetrates < 0 || m_caster.progressData.health <= 0) {
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
				if (skillshot.m_penetrates == 1) {
					//length on dictionary doesn't exist
					if (n != 0) {
						var keys:Array = distances.sort();
						en = closest[keys[0]];
						dealTargetDamage(en);
/*						if(AIUnit.m_enabled){
							SoundManager.playSound("hit");
						}		*/			
						//removeProjectile(skillshot);
					}
					
					skillshot.m_penetrates--;
				}
				else {
					// damage all closest units
					for (var i:String in closest) {
						en = closest[i];
						dealTargetDamage(en);
/*						if(AIUnit.m_enabled){
							SoundManager.playSound("hit");
						}		*/						
						skillshot.m_penetrates--;
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