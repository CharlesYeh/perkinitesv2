﻿package scripting.conditions {
	public class HasItemCondition extends Condition {
		
		/*
		 * Returns true if condition is passed
		 */
		override public function checkCondition():Boolean {
			return super.checkCondition() || true;
		}
	}
}