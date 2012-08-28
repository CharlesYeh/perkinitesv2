package scripting.actions {
	import game.Controls;
	
	public class ActionControls extends Action{
		/** whether to enable to disable controls */
		public var enable:Boolean;
		
		/** set of controls to enable/disable */
		public var set:String;
		
		override public function parseData(obj:Object):void {
			enable = obj.enable;
			set = obj.set;
		}
		
		override public function act():void {
			super.act();
			
			Controls.enabled = enable;
			complete();
		}
	}
}