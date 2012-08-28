package scripting.actions {
	import game.Game;
	
	public class ActionBlackout extends Action {
		
		public var text:String;
		
		override public function parseData(obj:Object):void {
			super.parseData(obj);
			
			text = obj.text;
		}
		
		override public function act():void {
			super.act();
			
			switch(subtype) {
				case "show":
					Game.overlay.fader.show(this, time);
					break;
					
				case "hide":
					Game.overlay.fader.hide(this, time);
					break;
					
				case "editText":
					Game.overlay.fader.editText(this, text);
					break;
					
			}
		}
	}
}