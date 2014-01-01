package db.dbData {
	import db.AbilityDatabase;
	import db.dbData.DatabaseData;
	import flash.utils.getDefinitionByName;
	
	
	public class BuffData implements DatabaseData {
		
		/*public var defenseMult:Number = 1;
		public var defenseAdd:int = 0;
		
		public var rangeMult:Number = 1;
		public var rangeAdd:int = 0;
		
		public var stun:Boolean = false;
		
		/** % of hp or set value to damage by
		public var poisonMult:Number = 0;
		public var poisonAdd:int = 0;
		
		/** whether this debuff shows the victim if invisible 
		public var detect:Boolean = false;
		
		/** whether this buff will make affected units invisible 
		public var vanish:Boolean = false;
		
		/** if > 0, then affects nearby units as well 
		public var auraRange:int = 0;
		public var auraMult:Number = 0;
		
		/** amount of health to add for heal 
		public var healAdd:int = 0;
		
		/** 1 = heal all of missing health 
		public var healMissingMult:Number = 0;
		
		public var invincibility:Boolean = false;
		
		public var moveMult:Number = 1;
		public var moveAdd:int = 0;*/
		
		/** base amount */
		public var base:Number;
		
		/** multiplicative mod */
		public var mod:Number;
		
		/** rate of increase per attack power */
		public var ratio:Number;
		
		/** the number of frames this buff will last */
		public var maxDuration:int;
		public var duration:int;
		
		//public const FIELDS:Array = new Array("defenseMult", "defenseAdd", /*"rangeMult", "rangeAdd", */"stun", "poisonMult", "poisonAdd", "detect", "vanish", "auraRange", "auraMult", "invincibility", "moveMult", "moveAdd", "duration");

		
		public static function createBuff(obj:Object):BuffData {
			var BuffClass:Class = AbilityDatabase.getBuffClass(obj.type);
			
			var buff:BuffData = new BuffClass();
			buff.parseData(obj);
			
			return buff;
		}
		
		public function parseData(obj:Object):void {
			base = (obj.base)? obj.base : 0;
			mod = (obj.mod)? obj.mod : 0;
			ratio = (obj.ratio)? obj.ratio : 0;
			maxDuration = obj.duration;
			duration = obj.duration;
		}
	}
}
