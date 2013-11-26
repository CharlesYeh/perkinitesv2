package game {
	import flash.display.MovieClip;
	
	import db.CharacterDatabase;
	import db.EnemyDatabase;
	import db.MapDatabase;
	import db.SequenceDatabase;
	import db.SoundDatabase;
	import db.SpeechDatabase;
	import db.dbData.CharacterData;
	import db.dbData.MapData;

	import events.GameEventDispatcher;
	
	import game.SoundManager;	
	import game.progress.PlayerProgress;
	
	import ui.GameOverlay;

	import units.StatUnit;
	import units.Perkinite;

	public class Game {
		private static var sndManager:SoundManager;
		public static var eventDispatcher:GameEventDispatcher;
		
		public static var dbEnemy:EnemyDatabase;
		public static var dbSeq:SequenceDatabase;
		public static var dbMap:MapDatabase;
		public static var dbChar:CharacterDatabase;
		public static var dbSnd:SoundDatabase;
		public static var dbSpch:SpeechDatabase;
		
		/** info about the player's progress is stored here */
		public static var playerProgress:PlayerProgress;
		
		/** the index of team the player is playing with */
		public static var teamIndex:int;
		
		/** array of current Perkinites */
		public static var team:Array = new Array();
		
		public static var gamePause:Boolean = false;
		
		/** container movieclip for maps */
		public static var container:MovieClip;
		
		public static var world:World;
		public static var overlay:GameOverlay;
		
		public static function init():void {
			sndManager = new SoundManager();
			eventDispatcher = new GameEventDispatcher();
			
			dbEnemy	= new EnemyDatabase();
			dbSeq	= new SequenceDatabase();
			dbMap	= new MapDatabase();
			dbChar	= new CharacterDatabase();
			dbSnd	= new SoundDatabase();
			dbSpch  = new SpeechDatabase();
			playerProgress = new PlayerProgress();
		}
		
		/**
		 * set the index of the team to start with (when startGameWorld is called)
		 */
		public static function chooseTeam(index:int):void {
			teamIndex = index;
		}
		
		public static function startGameWorld(cont:MovieClip):void {
			var START_SEPARATION:int = 15;
			
			container = cont;
			gamePause = false;
			
			team.splice(0);
			
			// create players
			var teamDat:Array = dbChar.getTeamCharacterData(teamIndex);
			Controls.startGameInputs();
			for (var i:int = 0; i < teamDat.length; i++) {
				var cdat:CharacterData = teamDat[i];
				
				var char:Perkinite = new Perkinite(cdat);
				char.x = GameConstants.TILE_SIZE * playerProgress.x + (GameConstants.TILE_SIZE >> 1) + i * START_SEPARATION;
				char.y = GameConstants.TILE_SIZE * playerProgress.y + (GameConstants.TILE_SIZE >> 1) + i;
				
				team.push(char);
			}
			
			// setup overlay
			
			overlay = new GameOverlay();	
			Game.overlay.hud.unitName1.text = teamDat[0].name;
			//Game.overlay.hud.unitName2.text = teamDat[1].name;		
			
			Game.overlay.hud.HPDisplay1.text = Game.playerProgress.health;
			Game.overlay.hud.HPDisplay2.text = teamDat[0].health;
			
			Game.overlay.hud.healthbar.FP.width = Game.playerProgress.health/teamDat[0].health * 190;
			
			Game.overlay.hud.visible = Game.playerProgress.hudVisible;
			Game.overlay.ehud.visible = Game.playerProgress.ehudVisible;
			Game.overlay.journal.setGoal(Game.playerProgress.goal);
			
			container.addChild(overlay);
			// create map/world
			world = MapManager.createWorld(Game.playerProgress.map);
			container.addChild(world);
			
			var tempIndex = container.getChildIndex(overlay);
			container.setChildIndex(overlay, container.getChildIndex(world));
			container.setChildIndex(world, tempIndex);
			
		}
		
		public static function endGameWorld():void {
			container.removeChild(world);
			container.removeChild(overlay);
			MapManager.resetWorld();
			world = null;
			
			team.splice(0);
			team.splice(0);
			
		}
		
		public static function moveTeam(horz:int, vert:int):void {
			if (horz == 0 && vert == 0) {
				return;
			}
			
			var lead:StatUnit = team[0];
			lead.moveDelta(horz, vert);
			
			for (var i:String in team) {
				var u:StatUnit = team[i];
				if (lead == u) {
					continue;
				}
				u.moveTo(lead.x, lead.y, true);		
			}
		}
		
		/**
		 * This is the main game loop.
		 */
		public static function update():void {
			// move player
			Controls.handleGameInputs();
			
			// screen follows player
			MapManager.update();
			
			// fps healing
			Player.updateHealing();
			
			//update journal
			Game.overlay.journal.updateGoal();
		}
	}
}