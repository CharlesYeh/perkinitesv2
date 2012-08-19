package db {
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	import com.adobe.serialization.json.*;
	import db.dbData.EnemyData;
	
	public class EnemyDatabase implements DatabaseLoader {
		
		/** path relative to game of enemy jsons */
		public static const PATH:String = "assets/data/enemies/";
		
		/** filename of file containing enemy json names */
		public static const BASE:String = "enemies";
		
		/** extension of all data files */
		public static const EXTENSION:String = ".json";
		
		/** dictionary of "enemy name" -> "EnemyData" */
		public var enemies:Dictionary = new Dictionary();
		
		public function EnemyDatabase() {
			loadData();
		}
		
		/**
		 * Load base data file to get references to detailed data
		 */
		public function loadData():void {
			Database.loadData(PATH + BASE + EXTENSION, completeLoad);
		}
		
		/**
		 * Callback from loading base file with enemy names
		 */
		function completeLoad(e:Event):void {
			var dat = JSON.decode(e.target.data);
			
			for (var enemyName:String in dat.enemies) {
				Database.loadData(PATH + dat.enemies[enemyName] + EXTENSION, completeLoadEnemy);
			}
		}
		
		/**
		 * Callback for loading data for one enemy
		 */
		function completeLoadEnemy(e:Event):void {
			var dat:Object = JSON.decode(e.target.data);
			
			var edat:EnemyData = new EnemyData();
			edat.parseData(dat);
			
			enemies[dat.name] = edat;
		}
		
		public function getSprite(id:String):String {
			var edat:EnemyData = enemies[id];
			return "assets/sprites/" + edat.sprite + ".swf";
		}
	}
	
}
