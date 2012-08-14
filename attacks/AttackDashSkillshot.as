package attacks {
	/**
	 * A skillshot attack which is cast in a line
	 * Range is used as the end destination of projectiles
	 */
	public class AttackDashSkillshot extends Attack {
		/** whether to stop movement at the first enemy hit */
		protected var stopAtEnemy:Boolean;
	}
}