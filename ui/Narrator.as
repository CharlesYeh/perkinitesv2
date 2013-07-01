package ui {
	import flash.display.MovieClip;
	import flash.display.Loader;
	import flash.text.TextFormat;
	
	import game.GameConstants;
	import scripting.actions.Action;
	
	public class Narrator extends MovieClip {
		
		var bold;
		public function Narrator() {
			visible = false;
			
			y = GameConstants.HEIGHT - height;
			//y = 8;
			bold = new TextFormat("Corbel", 16, 0xFFFFFF, true, false);
		}
		
		public function showText(text:String):void {
			visible = true;
			
			txtMessage.text = text;
			txtMessage.setTextFormat(bold);
			
			
		}
		public function hideText(act:Action):void {
			visible = false;
			act.complete();
		}		
	}
	
}
