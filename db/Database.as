package db {
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	public class Database {
		
		public function Database() {
			// constructor code
		}
		public static function loadData(url:String, completeLoad:Function) {
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, completeLoad);
			loader.load(new URLRequest(url));
		}
	}
}
