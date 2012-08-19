package db {
	import flash.utils.Dictionary;
	import flash.events.Event;
	
	import com.adobe.serialization.json.*;
	
	import db.dbData.CharacterData;
	
	public class CharacterDatabase implements DatabaseLoader {
		
		/** path relative to game of enemy jsons */
		public static const PATH:String = "assets/data/characters/";
		
		/** filename of file containing enemy json names */
		public static const BASE:String = "characters";
		
		/** extension of all data files */
		public static const EXTENSION:String = ".json";
		
		/** dictionary of name -> CharacterData */
		public var characters:Dictionary = new Dictionary();
		
		public function CharacterDatabase() {
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
			
			for (var charName:String in dat.characters) {
				Database.loadData(PATH + dat.characters[charName] + EXTENSION, completeLoadChar);
			}
		}
		
		function completeLoadChar(e:Event):void {
			var obj = JSON.decode(e.target.data);
			
			var cdat:CharacterData = new CharacterData();
			cdat.parseData(obj);
		}
	}
}