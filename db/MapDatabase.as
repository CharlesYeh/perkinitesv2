package db {
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	import com.adobe.serialization.json.*;
	
	import db.dbData.MapData;
	import db.dbData.TilesetData;
	
	public class MapDatabase implements DatabaseLoader {
		
		/** path relative to game of map jsons */
		public static const PATH:String = "assets/data/maps/";
		
		/** filename of file containing map json names */
		public static const TILESET_BASE:String = "tilesets";
		public static const BASE:String = "maps";
		
		/** extension of all data files */
		public static const EXTENSION:String = ".json";
		
		public var maps:Dictionary = new Dictionary();
		public var tilesets:Dictionary = new Dictionary();
		
		public function MapDatabase() {
			loadData();
		}

		/**
		 * Load tileset data file before loading base
		 */
		public function loadData():void {
			Database.loadData(PATH + TILESET_BASE + EXTENSION, completeTilesetLoad);
		}
		
		/**
		 * Parse tileset data, then load maps
		 */
		function completeTilesetLoad(e:Event):void {
			var tdat:Object = JSON.decode(e.target.data);
			for (var i:String in tdat.tilesets) {
				var tset:TilesetData = new TilesetData();
				tset.parseData(tdat.tilesets[i]);
				
				tilesets[tset.id] = tset;
			}
			
			Database.loadData(PATH + BASE + EXTENSION, completeBaseLoad);
		}
		
		function completeBaseLoad(e:Event):void {
			var dat = JSON.decode(e.target.data);
			
			for (var mapName:String in dat.maps) {
				Database.loadData(PATH + dat.maps[mapName] + EXTENSION, completeLoadMap);
			}
		}
		
		function completeLoadMap(e:Event):void {
			var dat:Object = JSON.decode(e.target.data);
			
			var mdat:MapData = new MapData();
			mdat.parseData(dat);
			
			maps[dat.name] = mdat;
		}
		
		public function getTileset(id:String):TilesetData {
			if (!tilesets.hasOwnProperty(id)) {
				trace("ERROR MapDatabase: tileset " + id + " doesn't exist");
			}
			
			return tilesets[id];
		}
	}
	
}
