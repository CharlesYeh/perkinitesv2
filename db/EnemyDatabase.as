package db {
	import flash.events.Event;
	
	import com.adobe.serialization.json.*;
	
	public class EnemyDatabase implements DatabaseLoader {
		
		/** path relative to game of enemy jsons */
		public static const PATH:String = "assets/data/enemies/";
		
		/** filename of file containing enemy json names */
		public static const BASE:String = "enemies.json";
		
		static var ai:Array, names:Array, sprites:Array, hp:Array, speed:Array;
		public static const ENEMY_ID_START = 10000;
		
		/**
		 * Load base data file to get references to detailed data
		 */
		public static function loadData():void {
			Database.loadData(PATH + BASE, completeLoad);
		}
		
		public static function getSprite(id:int) {
			return "assets/sprites/" + sprites[id - ENEMY_ID_START] + ".swf";
		}
		static function completeLoad(e:Event) {
			var dat = JSON.decode(e.target.data);
			
			for (var enemyName:String in dat.enemies) {
				Database.loadData(PATH + dat.enemies[enemyName], completeLoadEnemy);
			}
		}
		
		static function completeLoadEnemy(e:Event) {
			var dat = JSON.decode(e.target.data);
			
			ai		= new Array();
			names	= new Array();
			sprites	= new Array();
			hp		= new Array();
			speed	= new Array();
			
			var id = ENEMY_ID_START;
			for each (var node:XML in dat.Enemy) {
				ai.push(	node.AIClass);
				names.push(	node.Name);
				sprites.push(node.Sprite);
				hp.push(	parseInt(node.Health.attribute("Value")));
				speed.push(	parseInt(node.Speed.attribute("Value")));
				
				AbilityDatabase.addAbility(id++, node.Ability);
			}
		}
	}
	
}
