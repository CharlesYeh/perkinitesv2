﻿package db.dbData {
	
	public class TilesetData implements DatabaseData {
		public var id:String;
		public var types:Array;
		
		public function parseData(obj:Object):void {
			id		= obj.id;
			types	= obj.types;
		}
	}
	
}
