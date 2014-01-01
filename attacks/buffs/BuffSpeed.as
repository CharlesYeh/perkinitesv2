package attacks.buffs {
	
	import game.Game;
	import flash.utils.Dictionary;

	public class BuffSpeed extends Buff{
		
		override public function createBuff(buffs:Dictionary) {
			if(buffs.hasOwnProperty("speed")) {
				buffs["speed"].duration = Math.max(buffs["speed"].duration, duration);
				
			} else {
				buffs["speed"] = this;
			}
		}
	}
}