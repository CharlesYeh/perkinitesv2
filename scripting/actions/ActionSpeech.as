package scripting.actions {
	import db.ImageDatabase;
	import game.Game;
	import flash.display.Loader;
	
	public class ActionSpeech extends Action{
		
		public var icon:Loader;
		
		public var name:String;
		
		public var message:String;
		
		override public function parseData(obj:Object):void {
			super.parseData(obj);
			
			// TODO: get sprite from image cache
			icon = ImageDatabase.getIcon(obj.icon);
			name = obj.name;
			message = obj.message;
		}
		
		override public function act():void {
			Game.overlay.speech.showText(this, icon, name, message);
		}
	}
}