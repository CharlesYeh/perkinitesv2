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
		
		public var journal:Journal;
		
		/** clip for character speech */
		public var speech:Speech;
		
		/** clip for narrator speech */
		public var narrator:Narrator;
		
		/** clip for location display */
		public var locationDisplay:LocationDisplay;
		
		/** clip for gameover */
		public var gameover:GameOverScreen;
		
		/** clip for deciding things */
		public var decisionDisplay:DecisionDisplay;
		
		public function GameOverlay() {			
			journal = new Journal();
			journal.x = HUD_SPACING;
			//journal.y = GameConstants.HEIGHT - hud.height - 5 + 70;
			journal.y = 8;
			
			hud = new GameHUD();
			hud.x = HUD_SPACING;
			//hud.y = GameConstants.HEIGHT - hud.height - 5;
			hud.y = journal.y + journal.height + 8;
			
			ehud = new EnemyHUD();
			ehud.x = GameConstants.WIDTH - ehud.width - HUD_SPACING;
			//ehud.y = HUD_SPACING;
			ehud.y = GameConstants.HEIGHT - ehud.height - 5;
			ehud.visible = false;
			ehud.gotoAndStop("normal");
			
			speech = new Speech();
			
			narrator = new Narrator();
			
			locationDisplay = new LocationDisplay();
			locationDisplay.x = 504.5;
			//locationDisplay.y = 410;
			//locationDisplay.x = 8;
			locationDisplay.y = journal.y + journal.height + 8;
			
			charUnlock = new CharUnlock();
			charUnlock.x = 330;
			charUnlock.y = 240;
			
			fader = new BlackScreen();
			
			cutscene = new Cutscene();
			cutscene.visible = false;
			
			gameover = new GameOverScreen();
			gameover.visible = false;
			
			decisionDisplay = new DecisionDisplay();
			decisionDisplay.x = 320;
			decisionDisplay.y = 240;
			decisionDisplay.visible = false;
			
			addChild(hud);
			addChild(ehud);
			addChild(journal);
			addChild(locationDisplay);
			addChild(cutscene);
			addChild(charUnlock);
			addChild(fader);
			addChild(narrator);
			addChild(speech);
			addChild(decisionDisplay);
			addChild(gameover);
		}

	}
	
}
	