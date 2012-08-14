package attacks {
	public class Attack {
		protected var name:String, type:String;
		protected var icon:String, description:String;
		
		/** the range to which the player can cast this attack */
		protected var range:int;
		/** # of frames between consecutive attack uses */
		protected var cd:int;
		
		/** the base damage of this attack without additional scaling */
		protected var dmgBase:int;
		/** the ratio to which this attack scales */
		protected var dmgScale:Number;
		
		/** # of consecutive uses before the cooldown is applied */
		protected var uses:int;
	}
}