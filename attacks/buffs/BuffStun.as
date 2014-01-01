package attacks.buffs {
	
	import game.Game;
	import flash.utils.Dictionary;

	public class BuffStun extends Buff{
		
		override public function createBuff(buffs:Dictionary) {
			if(buffs.hasOwnProperty("stun")) {
				buffs["stun"].duration = Math.max(buffs["stun"].duration, duration);
				
			} else {
				buffs["stun"] = this;
			}
		}
	}
}