package scripting.actions {
	import game.Game;
	
	public class ActionBlackout extends Action {
		
		public var text:String;
		
		public var alpha:Number;
		
		override public function parseData(obj:Object):void {
			super.parseData(obj);
			
			text = obj.text;
			alpha = obj.alpha;
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
					
				case "showAlpha":
					Game.overlay.fader.alpha = alpha;
					complete();
					break;
			}
		}
	}
}