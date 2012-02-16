package db {
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	public class Database {
		
		public function Database() {
			// constructor code
		}
		public static function loadXML(url:String, completeLoad:Function) {
			var xmlLoader:URLLoader = new URLLoader();
			xmlLoader.addEventListener(Event.COMPLETE, completeLoad);
			xmlLoader.load(new URLRequest(url));
		}
	}
}
