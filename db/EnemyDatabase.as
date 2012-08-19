﻿package db {
	import flash.events.Event;
	
	import com.adobe.serialization.json.*;
	import flash.utils.Dictionary;
	import db.dbData.EnemyData;
	
	public class EnemyDatabase implements DatabaseLoader {
		
		/** path relative to game of enemy jsons */
		public static const PATH:String = "assets/data/enemies/";
		
		/** filename of file containing enemy json names */
		public static const BASE:String = "enemies";
		
		/** extension of all data files */
		public static const EXTENSION:String = ".json";
		
		public var enemies:Dictionary;
		
		public function EnemyDatabase() {
			enemies = new Dictionary();
			
			loadData();
		}
		
		/**
		 * Load base data file to get references to detailed data
		 */
		public function loadData():void {
			Database.loadData(PATH + BASE + EXTENSION, completeLoad);
		}
		
		public function getSprite(id:String) {
			var edat:EnemyData = enemies[id];
			return "assets/sprites/" + edat.sprite + ".swf";
		}
		function completeLoad(e:Event) {
			var dat = JSON.decode(e.target.data);
			
			for (var enemyName:String in dat.enemies) {
				Database.loadData(PATH + dat.enemies[enemyName] + EXTENSION, completeLoadEnemy);
			}
		}
		
		function completeLoadEnemy(e:Event) {
			var dat = JSON.decode(e.target.data);
			
			var edat = new EnemyData();
			edat.parseData(dat);
			
			enemies[dat.name] = edat;
		}
	}
	
}
