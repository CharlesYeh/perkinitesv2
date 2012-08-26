package attacks {
	import db.dbData.AttackData;
	import units.StatUnit;
	import game.Game;
	import flash.geom.Point;
	
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
			var dx = caster.x - castPoint.x;
			var dy = caster.y - castPoint.y;
			
			var dd = Math.sqrt(dx * dx + dy * dy);
			
			return (dd < range);
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
			caster.guide.guide_point.x = horizmult * (castPoint.x - caster.x);
			caster.guide.guide_point.y = castPoint.y - caster.y;
		}
		
		/**
		 * casts the ability at castPoint
		 */
		override public function castAbility(caster:StatUnit, castPoint:Point):void {
			super.castAbility(caster, castPoint);
		}
		
		override public function dealDamage():void {
			var enemies:Array = Game.world.getEnemies();
			
			for (var i:String in enemies) {
				var e:StatUnit = enemies[i];
				
				var dx:Number = e.x - m_castPoint.x;
				var dy:Number = e.y - m_castPoint.y;
				var dist:Number = Math.sqrt(dx * dx + dy * dy);
				
				if (dist < radius) {
					e.takeDamage(dmgBase);
				}
			}
		}
	}
}