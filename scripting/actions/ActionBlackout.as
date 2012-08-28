package scripting.actions {
	import game.Game;
	
	public class ActionBlackout extends Action {
		
		public var text:String;
		
		override public function parseData(obj:Object):void {
			super.parseData(obj);
			
			text = obj.text;
		}
		
		override public function act():void {
			Game.overlay.fader.show(time, this);
		}
	}
}