package db.dbData {
	import db.AbilityDatabase;
	import db.ImageDatabase;
	import flash.display.Loader;
	import flash.net.URLRequest;
	
	public class AttackData implements DatabaseData{
		public var name:String, type:String;
		public var icon:Loader, description:String;
		
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
			
			if (obj.icon != null && obj.icon != "") {
				icon = ImageDatabase.getIcon(obj.icon);
			}
			else {
				icon = new Loader();
			}
			
			description = obj.description;
			range = obj.range;
			cd = obj.cd;
			
			dmgBase = obj.dmgBase;
			dmgScale = obj.dmgRatio;
		}
	}
}