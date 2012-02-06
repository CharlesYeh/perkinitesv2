package game {
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.events.Event;

	public class Perkinite extends GameUnit {
		var swf;
		
		public function Perkinite(id) {
			// constructor code
			super();
			
			// load swf
			swf = new Loader();
			swf.load(new URLRequest("_sprites/JT.swf"));
			addChild(swf);
			
			swf.contentLoaderInfo.addEventListener(Event.COMPLETE, comp);
		}
		function comp(e) {
			swf.content.char.gotoAndStop("north");
		}
	}
}
