package game {
	public class Game {
		public static eventDispatcher:GameEventDispatcher;
		
		// TODO: add in world/map
		
		/** player variables are stored here */
		public static player:Player
		
		/** array of Perkinite's */
		public static team:Array;
		
		public static function init() {
			eventDispatcher = new GameEventDispatcher();
		}
	}
}