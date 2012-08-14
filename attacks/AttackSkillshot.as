package attacks {
	/**
	 * A skillshot attack which is cast in a line
	 * Range is used as the end destination of projectiles
	 */
	public class AttackSkillshot extends Attack {
		/** the width of the projectile */
		protected var width:int;
		
		/** # of enemies this attack will penetrate */
		/** 0 means the projectile is discarded after a single hit */
		protected var penetrates:int;
		
		/** travel speed of projectile */
		protected var speed:int;
	}
}