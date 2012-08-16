package scripting.conditions {
	public class ConditionHasItem {
		
		/*
		 * Returns true if condition is passed
		 */
		override public function checkCondition():Boolean {
			return super.checkCondition() || true;
		}
	}
}
