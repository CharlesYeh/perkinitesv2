package attacks {
	import db.dbData.AttackData;
	import units.AIUnit;
	import units.StatUnit;
	import game.Game;
	import flash.geom.Point;
	import game.SoundManager;
	
	import flash.events.Event;
	import flash.display.MovieClip;
	
	/**
	 * An attack which is cast on a circular shaped space.
	 */
	public class AttackPoint extends Attack {
		/** radius of the attack area */
		public var radius:int;
		
		override public function parseData(obj:Object):void {
			super.parseData(obj);
			
			radius = obj.radius;
		}
		
		/**
		 * returns whether or not the caster can cast to this point
		 */
		override public function inRange(caster:StatUnit, castPoint:Point):Boolean {
			/*var dx = caster.x - castPoint.x;
			var dy = caster.y - castPoint.y;
			
			var dd = Math.sqrt(dx * dx + dy * dy);
			
			return (dd < range);*/
			
			return super.inRange(caster, castPoint);
		}
		
		/**
		 * shows the guide aiming at castPoint
		 */
		override public function showGuide(caster:StatUnit, castPoint:Point):void {
			caster.guide.visible = true;
			// set range guide
			caster.guide.range_circle.width = caster.guide.range_circle.height =
							2 * range;
			
			var horizmult:int = (caster.scaleX > 0) ? 1 : -1;			
			caster.guide.gotoAndStop("point");
			caster.guide.guide_point.width = caster.guide.guide_point.height =
							2 * radius;
			caster.guide.guide_point.x = horizmult * (castPoint.x - caster.x);
			caster.guide.guide_point.y = castPoint.y - caster.y;
		}
		
		/**
		 * casts the ability at castPoint
		 */
		override public function castAbility(caster:StatUnit, castPoint:Point):void {
			var dx = castPoint.x - caster.x;
			var dy = castPoint.y - caster.y;
			
			var dd = Math.sqrt(dx * dx + dy * dy);
			
			
			if (dd < range) {
				// in range
			}
			else {
				castPoint.x = caster.x + dx / dd * range;
				castPoint.y = caster.y + dy / dd * range;
			}
			
			super.castAbility(caster, castPoint);
		}
		
		override public function pointAttack(bullets:Array, offset:Point, delay:int = -1):void {
			// get constructor and delete template
			var b:MovieClip = bullets[0];
			var projClass:Class = b.constructor;
			if(b.parent != null){
				b.parent.removeChild(b); 				
			}
			
			var p:MovieClip = new projClass();
			p.x = m_castPoint.x + offset.x;
			p.y = m_castPoint.y + offset.y;
			
			//get correct orientation
			p.rotation = b.rotation;
			p.delay = delay;
			//p.scaleX = (m_caster.scaleX > 0) ? 1 : -1;			
			
			
			p.addEventListener(Event.ENTER_FRAME, projectileRunner);
			Game.world.addUnit(p);
		}
		
		override public function dealDamage():void {
			damageHelper(m_castPoint);
		}
		
		/**
		 * enter frame handler for projectiles
		 */
		protected function projectileRunner(e:Event):void {
			var p:MovieClip = e.target as MovieClip;
			
			if(p.currentFrame == p.delay) {
				damageHelper(new Point(p.x, p.y));
			}
			
			if (p.currentFrame >= p.totalFrames) {
				removeProjectile(p);
			}
		}
		
		protected function removeProjectile(p:MovieClip):void {
			p.removeEventListener(Event.ENTER_FRAME, projectileRunner);
			Game.world.clearCustom(p);
		}		
		
		private function damageHelper(castPoint:Point) {
			var targets:Array = targets();
			
			for (var i:String in targets) {
				var e:StatUnit = targets[i];
				
				var dx:Number = e.x - castPoint.x;
				var dy:Number = e.y - castPoint.y;
				var dist:Number = Math.sqrt(dx * dx + dy * dy);
				
				if (dist < radius) {
					dealTargetDamage(e);
				}
				
			}
		}
	}
}