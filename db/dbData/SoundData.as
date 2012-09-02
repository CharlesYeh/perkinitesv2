package db.dbData {
	
	import flash.media.Sound;
	import flash.net.URLRequest;
	import flash.events.Event;
	
	public class SoundData implements DatabaseData {
		
		public const PATH:String = "assets/music/";
		
		/** name of song used in data */
		public var name:String;
		
		/** file name of song */
		public var src:Sound;
		
		/** intro file name if there is one */
		public var intro:Sound;
		
		public function parseData(obj:Object):void {
			name	= obj.name;
			
			src		= new Sound();
			src.load(new URLRequest(PATH + obj.src));
			
			if (obj.intro) {
				intro	= new Sound();
				intro.load(new URLRequest(PATH + obj.intro));
			}
		}
	}
	
}
