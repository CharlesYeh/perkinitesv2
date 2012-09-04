package ui {
	import flash.display.MovieClip;
	import game.GameConstants;
	
	public class GameOverlay extends MovieClip {
		private static var HUD_SPACING:int = 15;
		
		/** black screen fader */
		public var fader:BlackScreen;
		
		/** cutscene */
		public var cutscene:Cutscene;
		
		/** char unlock */
		public var charUnlock:CharUnlock;
		
		/** hud */
		public var hud:GameHUD;
		
		/** clip for character speech */
		public var speech:Speech;
		
		/** clip for narrator speech */
		public var narrator:Narrator;
		
		public function GameOverlay() {			
			hud = new GameHUD();
			hud.x = HUD_SPACING;
			hud.y = GameConstants.HEIGHT - hud.height - HUD_SPACING;
			
			speech = new Speech();
			
			narrator = new Narrator();
			
			charUnlock = new CharUnlock();
			charUnlock.x = 330;
			charUnlock.y = 240;
			
			fader = new BlackScreen();
			
			cutscene = new Cutscene();
			cutscene.visible = false;
			
			addChild(hud);
			addChild(cutscene);
			addChild(charUnlock);
			addChild(narrator);
			addChild(speech);
			addChild(fader);
		}

	}
	
}
	