package game {
	import flash.display.MovieClip;
	
	import db.EnemyDatabase;
	import db.MapDatabase;
	import db.CharacterDatabase;
	
	import db.dbData.CharacterData;
	
	import game.progress.PlayerProgress;
	
	import events.GameEventDispatcher;
	
	import units.StatUnit;
	import units.Perkinite;

	public class Game {
		public static var eventDispatcher:GameEventDispatcher;
		
		public static var dbEnemy:EnemyDatabase;
		public static var dbMap:MapDatabase;
		public static var dbChar:CharacterDatabase;
		
		/** info about the player's progress is stored here */
		public static var playerProgress:PlayerProgress;
		
		/** in-game player variables are stored here */
		public static var player:Player;
		
		/** the index of team the player is playing with */
		public static var teamIndex:int;
		
		/** array of current Perkinites */
		public static var team:Array;
		
		public static var gamePause:Boolean = false;
		
		/** container movieclip for maps */
		private static var container:MovieClip;
		
		private static var world:World;
		
		public static function init():void {
			eventDispatcher = new GameEventDispatcher();
			
			dbEnemy	= new EnemyDatabase();
			dbMap	= new MapDatabase();
			dbChar	= new CharacterDatabase();
			
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
			
			team = new Array();
			
			// create players
			var teamDat:Array = dbChar.getTeamCharacterData(teamIndex);
			Controls.startGameInputs();
			for (var i:int = 0; i < teamDat.length; i++) {
				var cdat:CharacterData = teamDat[i];
				
				var char:Perkinite = new Perkinite(cdat);
				char.x = GameConstants.TILE_SIZE * playerProgress.x + i * START_SEPARATION;
				char.y = GameConstants.TILE_SIZE * playerProgress.y;
				team.push(char);
			}
			
			// create map/world
			world = MapManager.createWorld(playerProgress.map, team);
			container.addChild(world);
		}
		
		public static function endGameWorld():void {
			container.removeChild(world);
			world = null;
			
			team = new Array();
			
			MapManager.resetWorld();
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
		
		public static function update():void {
			Controls.handleGameInputs();
			
			// follow player
			MapManager.update();
		}
	}
}