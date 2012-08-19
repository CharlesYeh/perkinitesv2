package db {
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	import com.adobe.serialization.json.*;
	
	public class MapDatabase implements DatabaseLoader {
		
		/** path relative to game of map jsons */
		public static const PATH:String = "assets/data/maps/";
		
		/** filename of file containing map json names */
		public static const BASE:String = "maps";
		
		/** extension of all data files */
		public static const EXTENSION:String = ".json";
		
		public var maps:Dictionary = new Dictionary();
		
		public function MapDatabase() {
			loadData();
		}

		/**
		 * Load base data file to get references to detailed data
		 */
		public function loadData():void {
			Database.loadData(PATH + BASE + EXTENSION, completeLoad);
		}
		
		function completeLoad(e:Event) {
			var dat = JSON.decode(e.target.data);
			
			for (var mapName:String in dat.maps) {
				Database.loadData(PATH + dat.maps[mapName] + EXTENSION, completeLoadMap);
			}
		}
		
		function completeLoadMap(e:Event) {
			var dat:Object = JSON.decode(e.target.data);
			
			var mdat:MapData = new MapData();
			mdat.parseData(dat);
			
			enemies[dat.name] = edat;
		}
	}
	
}
