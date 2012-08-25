package game{
	import db.dbData.MapData;
	import db.dbData.MapCharacterData;
	import db.dbData.TeleportData;

	import units.AIUnit;
	
	import flash.display.MovieClip;
	
    public class Map extends MovieClip {
		
		public var mapData:MapData;
		
		public var m_tiles:MovieClip;
		
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
			
			// create a mc to put tiles into, then place objects above it
			m_tiles = new MovieClip();
			addChild(m_tiles);
			
			// init teleports
			m_teleports = new Array();
			for (var i:String in mapData.teleports) {
				var t:TeleportData = mapData.teleports[i];
				createTeleport(t);
			}
			
			// init enemies
			m_enemies = new Array();
			for (i in mapData.enemies) {
				var e:MapCharacterData = mapData.enemies[i];
				createEnemy(e);
			}
			
			// init npcs
        }
		
		/**
		 * add this enemy to the map
		 */
		public function createEnemy(edat:MapCharacterData):void {
			var u:AIUnit = AIUnit.createAIUnit(edat.id);
			u.x = edat.position.x;
			u.y = edat.position.y;
			
			addChild(u);
			//u.setDeleteFunction(deleteEnemy);
			
			//addToMapClip(u);
			//aiUnits.push(u);
		}
		
		public function createTeleport(tdat:TeleportData):void {
			
		}
    }
}