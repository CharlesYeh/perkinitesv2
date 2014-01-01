package attacks.buffs {
	
	import flash.utils.Dictionary;
	
	import db.dbData.BuffData;
	
	import game.Game;
	import game.progress.PlayerProgress;
	import units.Perkinite;
	import units.StatUnit;
	
	public class Buff extends BuffData{
		
		private var m_complete:Boolean;
		protected var m_target:StatUnit;
		
		public function reset() {
			m_complete = false;
			duration = maxDuration;
		}
		
		public function startBuff(target:StatUnit) {
			m_target = target;
			if(target is Perkinite) {
				createBuff(Game.playerProgress.buffs);
			} else {
				createBuff(target.appliedBuffs);
			}
		}
		
		public function createBuff(buffs:Dictionary) {
			
		}
		
		public function applyBuff() {
			duration--;
			if(duration <= 0) {
				m_complete = true;
			}
		}
		
		public function update():Boolean {
			return m_complete;
		}
	}
}