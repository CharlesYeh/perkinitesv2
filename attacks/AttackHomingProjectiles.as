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
		
		override public function parseData(obj:Object):void {
			super.parseData(obj);
			
			hardTarget	= obj.hardTarget;
			expires		= (obj.expires) ? obj.expires : 9999;
		}
		
		override protected function prepareProjectile(p:MovieClip, ratio:Number):void {
			p.expires	= expires;
			p.radius	= 20;
			p.radians	= 2 * Math.PI * ratio;
		}
		
		override protected function projectileRunner(e:Event):void {
			var p:MovieClip = e.target as MovieClip;
			var target:StatUnit = p.target as StatUnit;
			
			if (target) {
				// locked on
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
					}
				}
				else {
					// soft target testing
					testSkillshotCollision(p);
				}
			}
			else {
				// still searching for target
				p.expires--;
				if (p.expires <= 0) {
					removeProjectile(p);
					return;
				}
				
				p.radians += .08;
				
				p.x = p.x * .5 + (m_caster.x + p.radius * Math.cos(p.radians)) * .5;
				p.y = p.y * .5 + (m_caster.y + p.radius * Math.sin(p.radians)) * .5;
				
				var targets:Array = targets();
				
				for (var i:String in targets) {
					var en:StatUnit = targets[i];
					
					if(StatUnit.distance(en, p) < range) {
						p.target = en;
					}
				}
			}
		}
		
	}
}