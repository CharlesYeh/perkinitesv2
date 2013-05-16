package attacks {
	import flash.geom.Point;
	
	import game.Game;
	import attacks.buffs.BuffUtil;
	
	import units.StatUnit;
	
	import db.dbData.AttackData;

	public class Attack extends AttackData {
		
		public var m_caster:StatUnit;
		public var m_castPoint:Point;
		
		/*public function clone():Attack {
			var AtkClass:Class = this.constructor;
			var atk:Attack = new AtkClass();
			atk.parseData(this);
			
			return atk;
		}*/
		
		/**
		 * returns whether or not the caster can cast to this point
		 */
		public function inRange(caster:StatUnit, castPoint:Point):Boolean {
			return true;
		}
		
		/**
		 * shows the guide aiming at castPoint
		 */
		public function showGuide(caster:StatUnit, castPoint:Point):void {
		}
		
		/**
		 * shows the guide aiming at castPoint
		 */
		public function updateGuide(caster:StatUnit, castPoint:Point):void {
			showGuide(caster, castPoint);
		}
		
		/**
		 * casts the ability at castPoint
		 */
		public function castAbility(caster:StatUnit, castPoint:Point):void {
			m_caster	= caster;
			m_castPoint	= castPoint;
		}
		
		/**
		 * updates the ability as its animation is playing
		 */
		public function castInProgress(caster:StatUnit):void {}
		
		/**
		 * calculate amount of damage to deal
		 */
		public function damage():int {
			return dmgBase;
		}
		
		public function targets():Array {
			return m_caster.abilityTargets;
		}
		
		//--------------FRAME FUNCTIONS----------------
		
		public function endAbility():void {}
		public function beginForwardMovement():void {}
		public function stopForwardMovement():void {}
		public function dealDamage():void {}
		
		public function applyBuffs():void {
			if (attackBuffs) {
				BuffUtil.applyBuffs(attackBuffs.self, m_caster);
				BuffUtil.applyBuffsToArray(attackBuffs.enemies, m_caster.abilityTargets);
				
				attackBuffs.allies;
				attackBuffs.team;
			}
		}
		
		public function pointAttack(bullets:Array):void {}
		
		public function shootSkillshot(bullets:Array):void {}
		
		public function shootDirectedSkillshot(bullets:Array, dir:Point, t:Number):void {}
		
		public function shootRelativeSkillshot(bullets:Array, angle:Number):void {}
		
		public function teleport():void {
			m_caster.teleportTo(m_castPoint.x, m_castPoint.y);
			m_caster.clearPath();
		}
		
		public function teleportPartner():void {
			for (var i:String in Game.team) {
				var u:StatUnit = Game.team[i];
				if (u == m_caster) {
					continue;
				}
				
				u.teleportTo(m_castPoint.x, m_castPoint.y);
				u.clearPath();
			}
		}
	}
}