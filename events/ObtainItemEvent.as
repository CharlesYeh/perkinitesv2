package events {
	import flash.events.Event;
	
	/*
	 * Fired whenever the player obtains a new item
	 */
	public class ObtainItemEvent extends Event {
		var items:Array;
		
		public function ObtainItemEvent(newItems:Array) {
			super(GameEventDispatcher.OBTAIN_ITEM);
			
			items = newItems;
		}
	}
}