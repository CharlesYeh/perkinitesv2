package events {
	import flash.events.Event;
	
	/*
	 * Fired whenever the player beats an enemy (or multiple)
	 */
	public class BeatEnemyEvent extends Event {
		var enemies:Array;
		
		public function BeatEnemyEvent(beat:Array) {
			super(GameEventDispatcher.BEAT_ENEMY);
			
			enemies = beat;
		}
	}
}