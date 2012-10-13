package  {
	import db.dbData.DatabaseData;
	import abilities.buffs.BuffData;
	
	public class AttackBuffData implements db.dbData.DatabaseData {
		
		/** buffs to apply to self */
		public var self:Array = new Array();
		
		/** buffs to apply to the whole team */
		public var team:Array = new Array();
		
		/** buffs to apply to allies */
		public var allies:Array = new Array();
		
		/** buffs to apply to enemies */
		public var enemies:Array = new Array();
		
		public function parseData(obj:Object):void {
			var fields:Array = new Array("self", "team", "allies", "enemies");
			
			for (var i:String in fields) {
				var key:String = fields[i];
				
				// parse each buff's data
				var buff:BuffData = new BuffData();
				buff.parseData(obj[key]);
				
				this[key].push(buff);
			}
		}
		
		public function applyBuffs() {
			
		}
	}
	
}
