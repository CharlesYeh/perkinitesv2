package db.dbData {
	import game.Game;
	import scripting.Sequence;
	import db.SequenceDatabase;
	
	public class MapData implements DatabaseData {
		
		public var name:String;
		public var id:String;
		public var width:int;
		public var height:int;
		
		public var tilesetData:TilesetData;
		
		/** code for grid of tiles */
		public var code:String;
		
		/** array of teleport points on map */
		public var teleports:Array = new Array();
		
		/** array of all enemies on map */
		public var enemies:Array = new Array();
		
		/** array of all npcs on map */
		public var npcs:Array = new Array();
		
		public var sequences:Array = new Array();
		
		public function parseData(obj:Object):void {
			name	= obj.name;
			id		= obj.id;
			
			code	= obj.code;
			
			width	= obj.width;
			height	= obj.height;
			
			tilesetData = Game.dbMap.getTileset(obj.tileset);
			
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
			
			for (i in obj.sequences) {
				var seqName:String = obj.sequences[i];
				
				// already parsed by sequence database
				var seq:Sequence = Game.dbSeq.getSequence(seqName)
				sequences.push(seq);
			}
		}
	}
}