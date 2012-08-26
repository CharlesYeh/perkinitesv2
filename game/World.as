package game{
	import db.dbData.MapData;
	import db.dbData.MapCharacterData;
	import db.dbData.TeleportData;

	import units.AIUnit;
	
	import flash.display.MovieClip;
	import units.GameUnit;
	import units.Teleport;
	
    public class World extends MovieClip {
		
		public var mapData:MapData;
		
		public var m_tiles:MovieClip;
		
		public var m_customs:Array;
		public var m_teleports:Array;
		public var m_enemies:Array;
		public var m_NPCs:Array;
		
        /**
		 * creates the world with MapData
         */
        public function World(mdat:MapData) {
			createWorld(mdat);
			// init npcs
        }
		
		public function createWorld(mdat:MapData):void {
			mapData = mdat;
			
			m_customs = new Array();
			
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
		}
		
		public function clearWorld():void {
			clearWorldHelper(m_customs);
			clearWorldHelper(m_teleports);
			clearWorldHelper(m_enemies);
			
			m_customs = null;
			m_teleports = null;
			m_enemies = null;
		}
		
		private function clearWorldHelper(clips:Array):void {
			for (var i:String in clips) {
				removeChild(clips[i]);
			}
		}
		
		/**
		 * custom-add units
		 */
		public function addUnit(u:GameUnit):void {
			m_customs.push(u);
			addChild(u);
		}
		
		/**
		 * add this enemy to the map
		 */
		public function createEnemy(edat:MapCharacterData):void {
			var u:AIUnit = AIUnit.createAIUnit(edat.id);
			u.x = edat.position.x;
			u.y = edat.position.y;
			
			m_enemies.push(u);
			addChild(u);
		}
		
		public function createTeleport(tdat:TeleportData):void {
			var t:Teleport = new Teleport(tdat);
			
			m_teleports.push(t);
			addChild(t);
		}
		
		public function checkTeleports(su:GameUnit) {
			var sx = Math.floor(su.x / GameConstants.TILE_SIZE);
			var sy = Math.floor(su.y / GameConstants.TILE_SIZE);
			
			for (var i:String in m_teleports) {
				var t:Teleport = m_teleports[i];
				
				if (sx == t.teleData.entryX && sy == t.teleData.entryY) {
					// change map!
					return t.teleData;
				}
			}
			
			return null;
		}
    }
}