package events {
	import flash.events.Event;
	
	/*
	 * Fired whenever the player reaches a teleport point
	 */
	public class ReachTeleportEvent extends Event {
		var items:Array;
		
		public function ReachTeleportEvent(newItems:Array) {
			super(GameEventDispatcher.REACH_TELEPORT);
			
			items = newItems;
		}
	}
}