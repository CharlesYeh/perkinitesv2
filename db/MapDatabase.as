package db {
	import flash.events.Event;
	
	public class MapDatabase implements DatabaseLoader {
		
		
		public var maps:Dictionary() = new Dictionary();
		
		public function MapDatabase() {
			enemies = new Dictionary();
			
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
			
			for (var enemyName:String in dat.enemies) {
				Database.loadData(PATH + dat.enemies[enemyName] + EXTENSION, completeLoadEnemy);
			}
		}
	}
	
}
