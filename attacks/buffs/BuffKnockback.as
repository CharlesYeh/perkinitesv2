package attacks.buffs {
	
	import game.Game;
	import flash.utils.Dictionary;
	import util.Vector2D;

	public class BuffKnockback extends Buff{
		
		public var d:Vector2D;
		
		override public function createBuff(buffs:Dictionary) {
			if(buffs.hasOwnProperty("knockback")) {
				buffs["knockback"].duration += base;
				
			} else {
				buffs["knockback"] = this;
				buffs["knockback"].duration = base;
			}
		}
		
		override public function applyBuff() {
			super.applyBuff();
		}
	}
}