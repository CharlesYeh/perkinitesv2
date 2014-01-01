package attacks.buffs {
	
	import flash.utils.Dictionary;
	
	import game.Game;
	import units.Perkinite;
	import units.StatUnit;
	
	public class BuffShield extends Buff{
		
		override public function startBuff(target:StatUnit) {
			m_target = target;
			if(target is Perkinite) {
				createBuff(Game.playerProgress.buffs);
				Game.playerProgress.shield += base;
				Game.overlay.hud.HPDisplay2.text = Game.playerProgress.shield;
			} else {
				createBuff(target.appliedBuffs);
				target.progressData.shield += base;
			}
		}			
		
		override public function createBuff(buffs:Dictionary) {
			if(buffs.hasOwnProperty("shield")) {
				buffs["shield"].duration = Math.max(buffs["shield"].duration, duration);
				
			} else {
				buffs["shield"] = this;
			}
			
		}
		override public function applyBuff() {
			super.applyBuff();
			if(duration <= 0) {
				if(m_target is Perkinite) {
					Game.playerProgress.shield = 0;	
					Game.overlay.hud.HPDisplay2.text = Game.playerProgress.shield;
				} else {
					m_target.progressData.shield = 0;
				}
			}
		}
	}
}