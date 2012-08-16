package scripting.conditions {
	public class Condition {
		
		protected var forceCompleted:Boolean = false;
		
		/*
		 * Returns true if condition is passed
		 */
		public function checkCondition():Boolean {
			return forceCompleted;
		}
	}
}
