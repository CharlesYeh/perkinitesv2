package scripting.conditions {
	public class Condition {
		
		protected var forceCompleted:Boolean = false;
		
		protected var callback:Function;
		
		/*
		 * Returns true if condition is passed
		 */
		public function checkCondition():Boolean {
			return forceCompleted;
		}
		
		protected function getConditionEventType():String {
			return "";
		}
		
		public function setCallback(cb:Function):void {
			callback = cb;
			Game.eventDispatcher.addEventListener(getConditionEventType(), updateCondition);
		}
		
		public function updateCondition(e:Event) {
			if (callback != null) {
				callback();
			}
		}
	}
}
