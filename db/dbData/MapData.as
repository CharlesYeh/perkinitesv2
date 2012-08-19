package db.dbData {
	import game.Game;
	
	public class MapData implements DatabaseData {
		
		public var name:String;
		public var id:String;
		public var width:int;
		public var height:int;
		
		public var tileset:TilesetData;
		
		/** code for grid of tiles */
		public var code:String;
		
		/** array of teleport points on map */
		public var teleports:Array = new Array();
		
		/** array of all enemies on map */
		public var enemies:Array = new Array();
		
		/** array of all npcs on map */
		public var npcs:Array = new Array();
		
		public function parseData(obj:Object):void {
			name	= obj.name;
			id		= obj.id;
			width	= obj.width;
			height	= obj.height;
			
			tileset = Game.dbMap.getTileset(obj.tileset);
			
			for (var i:String in obj.teleports) {
				var tdat:TeleportData = new TeleportData();
				tdat.parseData(obj.teleports[i]);
				teleports.push(tdat);
			}
			
			for (i in obj.enemies) {
				var cdat:MapCharacterData = new MapCharacterData();
				cdat.parseData(obj.enemies[i]);
				enemies.push(cdat);
			}
			
			for (i in obj.npcs) {
				cdat = new MapCharacterData();
				cdat.parseData(obj.npcs[i]);
				npcs.push(cdat);
			}
			
		}
	}
}