package scripting.actions {
	import game.Game;
	import game.SoundManager;
	
	public class ActionMusic extends Action{
		/** whether to enable to disable music */
		public var enable:Boolean;
		
		/** song to play */
		public var song:String;
		
		override public function parseData(obj:Object):void {
			super.parseData(obj);
			
			enable = obj.enable;
			song = obj.song;
		}
		
		override public function act():void {
			super.act();
			
			if (enable) {
				
			}
			else {
				SoundManager.endSong();
			}
			
			complete();
		}
	}
}