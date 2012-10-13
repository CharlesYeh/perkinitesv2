package db.dbData {
	import db.dbData.DatabaseData;

	public class BuffData implements DatabaseData {
		
		public var defenseMult:Number = 1;
		public var defenseAdd:int = 0;
		
		/*public var rangeMult:Number = 1;
		public var rangeAdd:int = 0;*/
		
		public var stun:Boolean = false;
		
		/** % of hp or set value to damage by */
		public var poisonMult:Number = 0;
		public var poisonAdd:int = 0;
		
		/** whether this debuff shows the victim if invisible */
		public var detect:Boolean = false;
		
		/** whether this buff will make affected units invisible */
		public var vanish:Boolean = false;
		
		/** if > 0, then affects nearby units as well */
		public var auraRange:int = 0;
		public var auraMult:Number = 0;
		
		/** amount of health to add for heal */
		public var healAdd:int = 0;
		
		/** 1 = heal all of missing health */
		public var healMissingMult:Number = 0;
		
		public var invincibility:Boolean = false;
		
		public var moveMult:Number = 1;
		public var moveAdd:int = 0;
		
		/** the number of frames this buff will last */
		public var duration:int;
		
		public const FIELDS:Array = new Array("defenseMult", "defenseAdd", /*"rangeMult", "rangeAdd", */"stun", "poisonMult", "poisonAdd", "detect", "vanish", "auraRange", "auraMult", "invincibility", "moveMult", "moveAdd", "duration");
		
		public function parseData(obj:Object):void {
			
			for (var i:String in FIELDS) {
				var key:String = FIELDS[i];
				
				// leave fields at default values if not specified in json
				if (obj.hasOwnProperty(key)) {
					this[key] = obj[key];
				}
			}
		}
	}
}
