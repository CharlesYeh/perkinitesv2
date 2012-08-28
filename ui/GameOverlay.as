package ui {
	import flash.display.MovieClip;
	import game.GameConstants;
	
	public class GameOverlay extends MovieClip {
		private static var HUD_SPACING:int = 15;
		
		/** black screen fader */
		public var fader:BlackScreen;
		
		/** hud */
		public var hud:GameHUD;
		
		/** clip for character speech */
		public var speech:Speech;
		
		public function GameOverlay() {
			hud = new GameHUD();
			hud.x = HUD_SPACING;
			hud.y = GameConstants.HEIGHT - hud.height - HUD_SPACING;
			
			speech = new Speech();
			
			fader = new BlackScreen();
			
			addChild(hud);
			addChild(speech);
			addChild(fader);
		}

	}
	
}
	