package attacks {
	import game.Game;
	import db.dbData.AttackData;
	import units.StatUnit;
	import flash.geom.Point;
	import flash.display.MovieClip;
	import flash.events.Event;
	
	/**
	 * projectiles appear around the caster which home-in on nearby targets
	 */
	public class AttackHomingProjectiles extends AttackSkillshot {
		
		/** once a target is chosen, whether the projectile will only hit */
		/** the chosen target or if it'll collide with other enemies first */
		public var hardTarget:Boolean = true;
		
		public var expires:int;
		
		public var wait:int = 0;
		
		//the enemies it targeted, try to divide it up
		protected var allTargets:Array;
		
		protected var targetIndex:int = 0;
		
		override public function parseData(obj:Object):void {
			super.parseData(obj);
			
			hardTarget	= obj.hardTarget;
			expires		= (obj.expires) ? obj.expires : 9999;
		}
		
		override public function castAbility(caster:StatUnit, castPoint:Point):void {
			super.castAbility(caster, castPoint);
			
			
			allTargets = new Array();
			targetIndex = 0;
		}
			
		override public function showGuide(caster:StatUnit, castPoint:Point):void{
			caster.guide.visible = true;
			// set range guide
			caster.guide.range_circle.width = caster.guide.range_circle.height =
							2 * range;
			
			caster.guide.gotoAndStop("smartcast");
		}
		
		override protected function prepareProjectile(p:MovieClip, ratio:Number):void {
			super.prepareProjectile(p, ratio);
			
			p.expires	= expires;
			p.radius	= 20;
			p.radians	= 2 * Math.PI * ratio;
		}
		
		override protected function projectileRunner(e:Event):void {
			var p:MovieClip = e.target as MovieClip;
			var target:StatUnit = p.target as StatUnit;
			
			if(m_caster.progressData.health <= 0){
				removeProjectile(p);
				return;
			}
			//hacky
			if(p.parent == null){
				p.removeEventListener(Event.ENTER_FRAME, projectileRunner);
				return;
			}
			if (target) {
				// locked on
				p.expires--;
				if (p.expires <= 0) {
					removeProjectile(p);
					return;
				}
				if(target.progressData.health <= 0){
					removeProjectile(p);
					return;
				}
				var dx:Number = target.x - p.x;
				var dy:Number = target.y - p.y;
				var dist:Number = Math.sqrt(dx * dx + dy * dy);
				p.x += speed * dx / dist;
				p.y += speed * dy / dist;
				
				if (hardTarget) {
					// hard target testing
					if (StatUnit.distance(target, p) < width) {
						target.takeDamage(damage());
						removeProjectile(p);
						return;
					}
				}
				else {
					// soft target testing
					if(testSkillshotCollision(p)){
						removeProjectile(p);
						return;
					}
				}
			}
			else {
				// still searching for target
				p.expires--;
				wait--;
				if (p.expires <= 0) {
					removeProjectile(p);
					return;
				}
				
				p.radians += .08;
				
				p.x = p.x * .5 + (m_caster.x + p.radius * Math.cos(p.radians)) * .5;
				p.y = p.y * .5 + (m_caster.y + p.radius * Math.sin(p.radians)) * .5;
				
				if(wait <= 0){
					var targets:Array = targets();
					
					for (var i:String in targets) {
						var en:StatUnit = targets[i];
						
						if(StatUnit.distance(en, p) < range && allTargets.indexOf(en) == -1) {
							allTargets.push(en);
							p.target = en;
							p.expires = expires;
							//wait = 120;
						}
					}
					if(p.target == null && allTargets.length > 0){
						p.target = allTargets[targetIndex];
						targetIndex++;
						if(targetIndex >= allTargets.length){
							targetIndex = 0;
						}
						//wait = 120;
					}
				}
			}
			
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
				p.m_penetrates = penetrates;
				p.expires = expires;
				Game.world.addUnit(p);
				
				m_bullets.push(p);
			}
		}
		
		override protected function testSkillshotCollision(skillshot:MovieClip):Boolean {
			var targets:Array = targets();
			var hit:Boolean = false;
			
			for (var a:String in targets) {
				var en:StatUnit = targets[a];
				
				if (StatUnit.distance(en, skillshot) < width) {
					//prevent multiple hits on the same enemy
					en.takeDamage(damage());
					// TODO: find actual closest to old position?
					
					// TODO: penetrate select amount
					m_penetrates--;
					return true;
				}
			}
			
			return hit;
		}		
	}
}