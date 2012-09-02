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
		
		public function showText(text:String):void {
			visible = true;
			
			txtMessage.text = text;
		}
		public function hideText(act:Action):void {
			visible = false;
			act.complete();
		}		
	}
	
}
