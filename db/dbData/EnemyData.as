package db.dbData {
	import db.AbilityDatabase;
	
	import attacks.Attack;
	
	public class EnemyData extends UnitData implements DatabaseData {
		
		public var ai:String;
		
		override public function parseData(obj:Object):void {
			super.parseData(obj);
			
			ai		= obj.ai;
		}
	}
}