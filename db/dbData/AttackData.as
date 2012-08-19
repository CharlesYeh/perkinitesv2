package db.dbData {
	import db.AbilityDatabase;
	
	public class AttackData implements DatabaseData{
		public var name:String, type:String;
		public var icon:String, description:String;
		
		/** the range to which the player can cast this attack */
		public var range:int;
		
		/** # of frames between consecutive attack uses */
		public var cd:int;
		
		/** the base damage of this attack without additional scaling */
		public var dmgBase:int;
		
		/** the ratio to which this attack scales */
		public var dmgScale:Number;
		
		/** # of consecutive uses before the cooldown is applied */
		public var uses:int;
		
		public static function createAttack(obj:Object):AttackData {
			var AttackClass:Class = AbilityDatabase.getAbilityClass(obj.type);
			
			var atk:AttackData = new AttackClass();
			atk.parseData(obj);
			
			return atk;
		}
		
		public function parseData(obj:Object):void {
			name = obj.name;
			type = obj.type;
			
			icon = obj.icon;
			description = obj.description;
		}
	}
}