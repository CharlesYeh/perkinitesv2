package abilities.buffs {
	public class Buff {
		/**
		defMultiplier
		defBonus
		rangeBonus
		stunDuration
		poisonDuration
		fear
		visibleDuration
		invisibleDuration
		*/
		
		/**
		 * values: upon activation, will apply buff to
		 *	TARGET:	enemies hit
		 *	SELF:	self
		 *	ALLIES:	partners but not self
		 *	TEAM:	self and partners
		 */
		public static const TARGET_TARGET:String	= "target";
		public static const TARGET_SELF:String		= "self";
		public static const TARGET_ALLIES:String	= "allies";
		public static const TARGET_TEAM:String		= "team";
		
		/** if > 0, then affects nearby enemies as well */
		public var range:int = 0;
		
		/** the number of frames this buff will last */
		public var duration:int;
		
		/** who to apply the buff to upon activation, see TARGET_? */
		public var target:String;
	}
}