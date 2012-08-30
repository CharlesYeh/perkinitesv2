package ui {
	import flash.display.MovieClip;
	import flash.display.Loader;
	
	import game.GameConstants;
	import scripting.actions.Action;
	
	public class Narrator extends MovieClip {
		
		public function Narrator() {
			visible = false;
			
			y = GameConstants.HEIGHT - height;
		}
		
		public function showText(act:Action, text:String):void {
			visible = true;
			act.complete();
			
			txtMessage.text = text;
		}
	}
	
}
