package db.dbData {
	public class TeleportData implements DatabaseData {
		
		public var entryX:int;
		public var entryY:int;
		
		public var exitMap:String;
		public var exitX:int;
		public var exitY:int;
		
		public function parseData(obj:Object):void {
			entryX	= obj.entry.x;
			entryY	= obj.entry.y;
			
			exitMap	= obj.exit.map;
			exitX	= obj.exit.x;
			exitY	= obj.exit.y;
		}
	}
}
