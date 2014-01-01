package db.dbData {
	import db.dbData.DatabaseData;
	import db.dbData.BuffData;
	
	public class AttackBuffData implements db.dbData.DatabaseData {
		
		/** buffs to apply to self */
		public var self:Array = new Array();
		
		/** buffs to apply to enemies */
		public var enemies:Array = new Array();
		
		
		public function parseData(obj:Object):void {
			var fields:Array = new Array("self", "enemies");
			
			for (var i:String in fields) {
				var key:String = fields[i];
				
				if (obj.hasOwnProperty(key)) {
					// parse each buff's data
					for (var j = 0; j < obj[key].length; j++) {
						var buff:BuffData = BuffData.createBuff(obj[key][j]);
					
						this[key].push(buff);
					}
				}
			}
		}
	}
	
}
