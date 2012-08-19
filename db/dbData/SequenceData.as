package db.dbData {
	import flash.geom.Point;
	
	public class SequenceData implements DatabaseData {
		public var name:String;
		public var actions:Array;
		
		public function parseData(obj:Object):void {
			name = obj.name;
			actions = obj.actions;
		}
	}
	
}
