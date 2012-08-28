package db {
	import flash.utils.Dictionary;
	import flash.display.Loader;
	import flash.net.URLRequest;

	public class ImageDatabase {
		/** dictionary of path -> Loader (image) */
		public static var images:Dictionary = new Dictionary();
		
		public static function getIcon(fileName:String):Loader {
			var path:String = "assets/icons/" + fileName;
			
			if (!images.hasOwnProperty(path)) {
				var req:URLRequest = new URLRequest(path);
				images[path] = new Loader();
				images[path].load(req);
			}
			
			return images[path];
		}
	}
}