package game {
	import db.EnemyDatabase;
	import db.MapDatabase;
	import db.CharacterDatabase;
	
	import game.progress.PlayerProgress;
	
	import events.GameEventDispatcher;
	import flash.display.MovieClip;
	import db.dbData.CharacterData;

	public class Game {
		public static var eventDispatcher:GameEventDispatcher;
		
		public static var dbEnemy:EnemyDatabase;
		public static var dbMap:MapDatabase;
		public static var dbChar:CharacterDatabase;
		
		public static var playerProgress:PlayerProgress;
		
		/** player variables are stored here */
		public static var player:Player;
		
		/** the index of team the player is playing with */
		public static var teamIndex:int;
		
		/** array of current Perkinites */
		public static var team:Array;
		
		public static var gamePause:Boolean = false;
		
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
		
		public static function startGameWorld(container:MovieClip):void {
			gamePause = false;
			
			// create players
			var teamDat:Array = dbChar.getTeamCharacterData(teamIndex);
			Controls.startGameInputs();
			for (var i:String in teamDat) {
				var cdat:CharacterData = teamDat[i];
				
				//var char:Perkinite = new Perkinite(cdat);
				//team.push(char);
			}
			
			// create map/world
			/*container.addChild(MapManager.mapClip);
			container.setChildIndex(hud, numChildren - 1);
			MapManager.loadMap(map, player, partner);
			MapManager.addToMapClip(player);
			MapManager.addToMapClip(partner);*/
			
			//MapManager.setHeroPosition(player, partner, startPoint);
		}
		
		public static function endGameWorld():void {
			// clear characters
			for (var i:String in team) {
				team[i];
			}
			
			team = new Array();
			
			// clear map
			/*MapManager.clearTelePoints();
			MapManager.clearAIUnits();
			MapManager.clearNPCUnits();
			MapManager.removeFromMapClip(player);
			MapManager.removeFromMapClip(partner);*/
		}
	}
}