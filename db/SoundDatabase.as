package db {
	import flash.utils.Dictionary;
	import flash.events.Event;
	
	import com.adobe.serialization.json.JSON;
	
	import db.dbData.SoundData;
	
	public class SoundDatabase implements DatabaseLoader {
		
		/** dictionary of sndname -> SoundData */
		public var sounds:Dictionary = new Dictionary();
		
		public function SoundDatabase() {
			loadData();
		}
		
		public function loadData():void {
			Database.loadData("assets/data/sounds.json", completeLoad);
		}
		
		public function completeLoad(e:Event):void {
			var sdat:Object = JSON.decode(e.target.data);
			
			for (var i:String in sdat.music) {
				var dat:Object = sdat.music[i];
				
				var snd:SoundData = new SoundData();
				snd.parseData(dat);
				sounds[snd.name] = snd;
			}
		}
		
		public function getSoundData(name:String):SoundData {
			return sounds[name];
		}
	}
}
