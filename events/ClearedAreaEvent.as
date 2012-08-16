package events {
	import flash.events.Event;
	
	/*
	 * Fired whenever the player clears an area (finishes it)
	 */
	public class ClearedAreaEvent extends Event {
		public function ClearedAreaEvent(newItems:Array) {
			super(GameEventDispatcher.CLEARED_AREA);
		}
	}
}