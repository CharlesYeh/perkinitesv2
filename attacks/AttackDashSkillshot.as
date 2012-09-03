﻿package attacks {
	import db.dbData.AttackData;
	import units.StatUnit;
	import flash.geom.Point;
	
	/**
	 * A skillshot attack which is cast in a line
	 * Range is used as the end destination of projectiles
	 */
	public class AttackDashSkillshot extends AttackSkillshot {
		
		/** whether this */
		public var m_moveForward:Boolean = false;
		public var m_multi:int;
		public var m_forwardVector:Point;
		
		override public function parseData(obj:Object):void {
			super.parseData(obj);
		}
		
		override public function showGuide(caster:StatUnit, castPoint:Point):void{
			super.showGuide(caster, castPoint);
		}
		
		override public function castAbility(caster:StatUnit, castPoint:Point):void {
			super.castAbility(caster, castPoint);
			
			m_moveForward = false;
			
			var dx:Number = castPoint.x - caster.x;
			var dy:Number = castPoint.y - caster.y;
			var d:Number = Math.sqrt(dx * dx + dy * dy);
			dx = dx / d;
			dy = dy / d;
			
			// times to check a frame dash
			m_multi = Math.floor(speed / 10) + 1;
			var speedChunk:Number = speed / m_multi;
			
			m_forwardVector = new Point(dx * speedChunk, dy * speedChunk);
		}
		
		override public function castInProgress(caster:StatUnit):void {
			super.castInProgress(caster);
			
			if (m_moveForward) {
				// move forward!!
				for (var i:int = 0; i < m_multi; i++) {
					if (!caster.teleportTo(caster.x + m_forwardVector.x, caster.y + m_forwardVector.y)) {
						break;
					}
				}
				
				caster.clearPath();
				
				// caster is the skillshot projectile
				if (testSkillshotCollision(caster) && m_penetrates <= 0) {
					// stop dashing and ability
					stopForwardMovement();
					
					caster.enableMovement();
					caster.endAbility();
				}
			}
		}
		
		override public function beginForwardMovement():void {
			m_moveForward = true;
		}
		
		override public function stopForwardMovement():void {
			m_moveForward = false;
		}
	}
}