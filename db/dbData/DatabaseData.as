package db.dbData {
	public interface DatabaseData {
		public static function parseData(obj:Object):DatabaseData;
		public function populateData(dbData:DatabaseData, obj:Object):void;
	}
}