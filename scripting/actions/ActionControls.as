package scripting.actions {
	import game.Controls;
	import flash.utils.Dictionary;
	
	public class ActionControls extends Action{
		/** whether to enable to disable controls, overrides everything */
		public var enable:Boolean; //rename
		
		public var enables:Dictionary = new Dictionary();
		public const enabled:String = "enabled";
		public const leftEnabled:String = "leftEnabled";
		public const rightEnabled:String = "rightEnabled";
		public const movementEnabled:String = "movementEnabled";
		public const teamEnabled:String = "teamEnabled";
		
		override public function parseData(obj:Object):void {
			enable = obj.enable;
			
			if(obj.enabled != null) {
				enables[enabled] = obj.enabled;
			}
			if(obj.leftEnabled != null) {
				enables[leftEnabled] = obj.leftEnabled;
			}
			if(obj.rightEnabled != null) {
				enables[rightEnabled] = obj.rightEnabled;
			}
			if(obj.movementEnabled != null) {
				enables[movementEnabled] = obj.movementEnabled;
			}
			if(obj.teamEnabled != null) {
				enables[teamEnabled] = obj.teamEnabled;
			}
		}
		
		override public function act():void {
			super.act();
			
			Controls.enabled = enable; //disable this later haha
			
			if(enables.hasOwnProperty(enabled)) {
				Controls.enabled = enables[enabled];
				Controls.leftEnabled = enables[enabled];
				Controls.rightEnabled = enables[enabled];
				Controls.movementEnabled = enables[enabled];
				Controls.teamEnabled = enables[enabled];
			} 
			if(enables.hasOwnProperty(leftEnabled)) {
				Controls.leftEnabled = enables[leftEnabled];
			} 			
			if(enables.hasOwnProperty(rightEnabled)) {
				trace(enables[rightEnabled]);
				Controls.rightEnabled = enables[rightEnabled];
			} 		
			if(enables.hasOwnProperty(movementEnabled)) {
				Controls.movementEnabled = enables[movementEnabled];
			} 		
			if(enables.hasOwnProperty(teamEnabled)) {
				Controls.teamEnabled = enables[teamEnabled];
			} 	
			
			complete();
		}
	}
}