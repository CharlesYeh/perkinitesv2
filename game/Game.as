package game {
	import db.EnemyDatabase;
	import db.MapDatabase;
	import db.CharacterDatabase;
	
	import events.GameEventDispatcher;

	public class Game {
		public static var eventDispatcher:GameEventDispatcher;
		
		public static var dbEnemy:EnemyDatabase;
		public static var dbMap:MapDatabase;
		public static var dbChar:CharacterDatabase;
		
		// TODO: add in world/map
		
		/** player variables are stored here */
		public static var player:Player
		
		/** array of Perkinite's */
		public static var team:Array;
		
		public static function init() {
			eventDispatcher = new GameEventDispatcher();
			
			dbEnemy	= new EnemyDatabase();
			dbMap	= new MapDatabase();
			dbChar	= new CharacterDatabase();
			
		}
	}
}