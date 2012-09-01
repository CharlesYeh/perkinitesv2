package events {
	import flash.events.Event;
	
	/*
	 * Fired whenever the player beats an enemy 
	 */
	public class BeatEnemyEvent extends Event {
		public var id;
		
		public function BeatEnemyEvent(eID:String) {
			super(GameEventDispatcher.BEAT_ENEMY);
			
			id = eID;
		}
	}
}