package db.dbData {
	import db.AbilityDatabase;
	import db.ImageDatabase;

	import flash.display.MovieClip;
	import flash.display.Loader;
	
	import flash.events.IOErrorEvent;

	import flash.net.URLRequest;
	
	import flash.utils.Dictionary;

	public class SpeechData implements DatabaseData {
		
		/** dictionary of speech type -> Array of Strings */
		private var speeches:Dictionary = new Dictionary();
		
		private var speechIndex:int = 0;
		
		public var name:String;
		public var id:String;
		
		public function parseData(obj:Object):void {
			name = obj.name;
			id = obj.id;
			
			for (var speechId:String in obj.speech) {
				var speech = obj.speech[speechId];
				speeches[speech.name] = speech.lines;
			}
		}
		
		public function getSpeech(id:String) {
			if(!speeches.hasOwnProperty(id)) {
				return null;
			}
			
			if (id == "field" || id == "npc") {
				if (speeches[id].length <= speechIndex) {
					speechIndex = 0;
				}
				var line = speeches[id][speechIndex];
				speechIndex++;
				return line;
			} else {
				var speech = speeches[id];
				return speech[Math.floor(Math.random() * speech.length)]; 
			}
		}
	}
}