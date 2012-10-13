package attacks.buffs {
	import units.StatUnit;
	import game.progress.BuffProgress;
	import db.dbData.BuffData;
	
	public class BuffUtil {
		/**
		 * Update buffs, then return the effects for this frame
		 */
		public static function updateBuffs(arr:Array):BuffProgress {
			for (var i:int = 0; i < arr.length; i++) {
				var b:BuffProgress = arr[i];
				if (--b.duration <= 0) {
					arr.splice(i, 1);
				}
			}
			
			if (arr.length > 0) {
				return arr[0];
			}
			else {
				return null;
			}
		}
		
		/**
		 * Use to apply buffs onto a target
		 */
		public static function applyBuffs(arr:Array, su:StatUnit):void {
			for (var i:int = 0; i < arr.length; i++) {
				var b:BuffData = arr[i];
				
				var bp:BuffProgress = new BuffProgress();
				bp.parseData(b);
				
				su.addBuff(bp);
			}
		}
		
		public static function applyBuffsToArray(arr:Array, uns:Array):void {
			for (var i:int = 0; i < uns.length; i++) {
				applyBuffs(arr, uns[i]);
			}
		}
	}
}