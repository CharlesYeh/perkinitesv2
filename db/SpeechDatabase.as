package db {
	import flash.events.Event;
	
	import flash.utils.Dictionary;
	
	import com.adobe.serialization.json.*;
	
	import db.dbData.SpeechData;
	
	public class SpeechDatabase implements DatabaseLoader {
		/** path relative to game of speech jsons */
		public static const PATH:String = "assets/data/speech/";
		
		/** filename of file containing speech json names */
		public static const BASE:String = "speech";
		
		/** extension of all data files */
		public static const EXTENSION:String = ".json";
		
		/** dictionary of name -> SpeechData */
		public var speeches:Dictionary = new Dictionary();
		
		/** array -> array (team) -> strings (characters within team) */
		public var teams:Array = new Array();
		
		/** cache of team id -> array of CharacterData */
		public var teamData:Dictionary = new Dictionary();
		
		public function SpeechDatabase() {
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
			var dat = JSON_.decode(e.target.data);
			
			for (var charName:String in dat.characters) {
				Database.loadData(PATH + dat.characters[charName] + EXTENSION, completeLoadSpeech);
			}
		}
		
		function completeLoadSpeech(e:Event):void {
			var obj = JSON_.decode(e.target.data);
			
			var sdat:SpeechData = new SpeechData();
			sdat.parseData(obj);
			
			speeches[sdat.id] = sdat;
		}
		
		public function getAllSpeechData():Dictionary {
			return speeches;
		}
		
		public function getSpeechData(id:String):SpeechData {
			return speeches[id];
		}
		
		public function getName(id:String):String {
			return speeches[id].name;
		}
		
		public function getSpeech(id:String, type:String):String {
			return speeches[id].getSpeech(type);
		}
	}
}