package game{
	import db.dbData.MapData;
	import db.dbData.MapCharacterData;
	import db.dbData.TeleportData;

	import units.AIUnit;

    public class Map {
		
		public var mapData:MapData;
		
		public var m_teleports:Array;
		public var m_enemies:Array;
		public var m_NPCs:Array;

        /**
		 * @param ID The ID of the map
         * @param mapCode The information to parse of the map.
         * @param mapName The name of the map.
		 * @param TilesetID The ID of the Tileset to use
         * @param BGM The tile set of the map.
         * @param BGS The array containing the map.
         */

        public function Map(mdat:MapData) {
			mapData = mdat;
			
			// init teleports
			m_teleports = new Array();
			for (var i:String in mapData.teleports) {
				var t:TeleportData = mapData.teleports[i];
				
			}
			
			// init enemies
			m_enemies = new Array();
			for (i in mapData.enemies) {
				var e:MapCharacterData = mapData.enemies[i];
				
			}
			
			// init npcs
        }
		
		public static function createEnemy(edat:MapCharacterData):void {
			var u = AIUnit.createAIUnit(edat.id);
			u.x = edat.position.x;
			u.y = edat.position.y;
			u.setDeleteFunction(deleteEnemy);
			
			addToMapClip(u);
			aiUnits.push(u);
			
			return u;
		}
    }
}