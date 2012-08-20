package events {
	import flash.events.Event;
	
	/*
	 * Fired whenever the player clears an area (finishes it)
	 */
	public class RightClickEvent extends Event {
		public function RightClickEvent() {
			super(GameEventDispatcher.RIGHT_CLICK);
		}
	}
}