package abilities.buffs {
	import db.dbData.DatabaseData;

	public class BuffData implements DatabaseData {
		
		public var defenseMult:Number = 1;
		public var defenseAdd:int = 0;
		
		public var rangeMult:Number = 1;
		public var rangeAdd:int = 0;
		
		public var stun:Boolean = false;
		
		public var poisonMult:Number = 1;
		public var poisonAdd:int = 0;
		
		/** whether this debuff shows the victim if invisible */
		public var detect:Boolean = false;
		
		/** whether this buff will make affected units invisible */
		public var vanish:Boolean = false;
		
		/** if > 0, then affects nearby enemies as well */
		public var auraRange:int = 0;
		public var auraMult:Number = 0;
		
		/** the number of frames this buff will last */
		public var duration:int;
		
		public function parseData(obj:Object):void {
			var fields:Array = new Array("defenseMult", "defenseAdd", "rangeMult", "rangeAdd", "stun", "poisonMult", "poisonAdd", "detect", "vanish", "auraRange", "auraMult", "duration");
			
			for (var i:String in fields) {
				var key:String = fields[i];
				
				// leave fields at default values if not specified in json
				if (obj.hasOwnProperty(key)) {
					this[key] = obj[key];
				}
			}
		}
	}
}
