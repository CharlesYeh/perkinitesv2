package ui{
	
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.*;
	import flash.ui.*;
	import flash.filters.GlowFilter;
	import flash.net.SharedObject;
	
	import game.Game;
	import game.Controls;
	
	public class GameOverScreen extends MovieClip { 

		public function GameOverScreen() {
			//var gf1=new GlowFilter(0xFF9900,100,20,20,1,5,true,false);
			
			//retryButton.buttonText.text="Retry!";
			//loadButton.buttonText.text="Load Game";

			//retryButton.addEventListener(MouseEvent.CLICK, retry);
			//loadButton.addEventListener(MouseEvent.CLICK, loadGame);
			//addEventListener(KeyboardEvent.KEY_DOWN, retry);
			//load();
		}
		
		public function retry(e){
			/*var retry = SharedObject.getLocal("RetryLevel");
			Unit.currentUnit = retry.data.currentUnit;
			Unit.partnerUnit = retry.data.partnerUnit;
			retry.clear();
			*/
			//removeDisplay();
			//unload();
			
			
			//load save data
			Controls.enabled = true;
			Game.overlay.gameover.visible = false;

		}
	}
}