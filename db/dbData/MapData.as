package db.dbData {
	public class MapData implements DatabaseData {
		
		public var name:String;
		public var id:String;
		public var sprite:String;
		public var ai:String;
		
		public var health:int;
		public var defense:int;
		public var speed:int;
		public var abilities:Array;
		
		public function parseData(obj:Object):void {
			
		}
	}
}