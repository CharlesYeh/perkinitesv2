package db.dbData {
	import scripting.Sequence;
	import scripting.conditions.ConditionBeatEnemy;
	import scripting.actions.Action;

	public class TeleportData implements DatabaseData {
		
		public var entryX:int;
		public var entryY:int;
		
		public var exitMap:String;
		public var exitX:int;
		public var exitY:int;
		
		public var conditions:Array;
		
		public function parseData(obj:Object):void {
			entryX	= obj.entry.x;
			entryY	= obj.entry.y;
			
			exitMap	= obj.exit.map;
			exitX	= obj.exit.x;
			exitY	= obj.exit.y;
			
			conditions = new Array();
			
			for (var i:String in obj.conditions) {
				var cdat:Object = obj.conditions[i];
				
				var cond:Action = Sequence.createAction(cdat.type);
				cond.parseData(cdat);
				conditions.push(cond);
			}
		}
	}
}
