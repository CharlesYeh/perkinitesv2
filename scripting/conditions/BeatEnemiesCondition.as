package scripting.conditions {
	public class BeatEnemiesCondition extends Condition {
		
		/*
		 * Returns true if condition is passed
		 */
		override public function checkCondition():Boolean {
			return super.checkCondition() || true;
		}
		
		override protected function getConditionEventType():String {
			return Game.eventDispatcher.BEAT_ENEMY;
		}
	}
}
