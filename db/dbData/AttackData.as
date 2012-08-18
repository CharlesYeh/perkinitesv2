package db.dbData {
	import flash.utils.getDefinitionByName;
	
	import attacks.*;
	
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
		
		public static function parseData(obj:Object):void {
			var AttackClass:Class = getDefinitionByName(obj.type);
			var attack:AttackData = AttackClass.parseData(obj);
		}
		
		public function populateData(dbData:DatabaseData, obj:Object):void {
			var atk:AttackData = dbData as AttackData;
			atk.name = obj.name;
			atk.type = obj.type;
			
			atk.icon = obj.icon;
			atk.description = obj.description;
		}
	}
}