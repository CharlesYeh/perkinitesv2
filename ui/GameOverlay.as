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
		public var ehud:EnemyHUD;
		
		/** clip for character speech */
		public var speech:Speech;
		
		/** clip for narrator speech */
		public var narrator:Narrator;
		
		/** clip for location display */
		public var locationDisplay:LocationDisplay;
		
		/** clip for gameover */
		public var gameover:GameOverScreen;
		
		public function GameOverlay() {			
			hud = new GameHUD();
			hud.x = HUD_SPACING;
			hud.y = GameConstants.HEIGHT - hud.height - HUD_SPACING;
			
			
			ehud = new EnemyHUD();
			ehud.x = GameConstants.WIDTH - ehud.width - HUD_SPACING;
			ehud.y = HUD_SPACING;
			ehud.visible = false;
			ehud.gotoAndStop("normal");
			
			speech = new Speech();
			
			narrator = new Narrator();
			
			locationDisplay = new LocationDisplay();
			locationDisplay.x = 515;
			locationDisplay.y = 425;
			
			charUnlock = new CharUnlock();
			charUnlock.x = 330;
			charUnlock.y = 240;
			
			fader = new BlackScreen();
			
			cutscene = new Cutscene();
			cutscene.visible = false;
			
			gameover = new GameOverScreen();
			gameover.visible = false;
			
			addChild(hud);
			addChild(ehud);
			addChild(locationDisplay);
			addChild(cutscene);
			addChild(charUnlock);
			addChild(narrator);
			addChild(speech);
			addChild(fader);
			addChild(gameover);
		}

	}
	
}
	