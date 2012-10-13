package events {
	import flash.events.Event;
	
	/*
	 * Fired whenever the player obtains a new item
	 */
	public class ObtainItemEvent extends Event {
		var items:String;
		
		public function ObtainItemEvent(newItem:String) {
			super(GameEventDispatcher.OBTAIN_ITEM);
			
			items = newItem;
		}
	}
}