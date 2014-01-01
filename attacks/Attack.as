﻿package attacks {
	import flash.geom.Point;
	
	import game.Game;
	import attacks.buffs.BuffUtil;
	
	import units.AIUnit;
	import units.StatUnit;
	
	import db.dbData.AttackData;

	public class Attack extends AttackData {
		
		public var m_caster:StatUnit;
		public var m_castPoint:Point;
		public var ratio:Number = 1;
		
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
		
		public function dealTargetDamage(target:StatUnit) {
			target.takeDamage(damage(), name);	
			for(var i = 0; i < attackBuffs.enemies.length; i++) {
				attackBuffs.enemies[i].startBuff(target);
			}				
		}
		/**
		 * calculate amount of damage to deal
		 */
		public function damage():int {
			return Math.floor(dmgBase * ratio);
		}
		
		public function targets():Array {
			return m_caster.abilityTargets;
		}
		
		//--------------FRAME FUNCTIONS----------------
		
		public function endAbility():void {}
		public function beginForwardMovement():void {}
		public function stopForwardMovement():void {}
		public function dealDamage():void {}
		
		public function setDamageRatio(damageRatio:Number):void {
			ratio = damageRatio;
		}
		
		public function applyBuffs():void {
			if (attackBuffs) {
				
				for(var i = 0; i < attackBuffs.self.length; i++) {
					attackBuffs.self[i].startBuff(m_caster);
				}
				//BuffUtil.applyBuffs(attackBuffs.self, m_caster);
				//BuffUtil.applyBuffsToArray(attackBuffs.enemies, m_caster.abilityTargets);
				
				//attackBuffs.allies;
				//attackBuffs.team;
			}
		}
		
		public function prepareCastPoint():void {
			m_castPoint = m_caster.prepareCastPoint();
		}
		
		public function prepareRandomPoint(radius:int):void {
			prepareCastPoint();
			if (m_castPoint != null) {
				var rand = Math.random() * Math.PI * 2;
				m_castPoint.x = m_castPoint.x + radius * Math.cos(rand);
				m_castPoint.y = m_castPoint.y + radius * Math.sin(rand);
				
				trace(radius * Math.cos(rand) + " " + radius * Math.sin(rand));
			}
		}
		public function pointAttack(bullets:Array, offset:Point, delay:int = -1):void {}
		
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

		public function getAttackType():String {
			return "";
		}
	}
}