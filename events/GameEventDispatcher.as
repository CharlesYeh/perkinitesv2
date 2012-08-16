package events {
	import fl.events.EventDispatcher;
	public function GameEventDispatcher extends EventDispatcher {
		
		public static const BEAT_ENEMY:String	= "BEAT_ENEMY";
		public static const CLEARED_AREA:String	= "CLEARED_AREA";
		public static const OBTAIN_ITEM:String	= "OBTAIN_ITEM";
		public static const REACH_TELEPORT:String	= "REACH_TELEPORT";
	}
}