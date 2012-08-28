package scripting.actions {
	public class ActionNarrator extends Action {
		
		public var text:String;
		
		override public function parseData(obj:Object):void {
			super.parseData(obj);
			
			text = obj.text;
		}
		
		override public function act():void {
			
		}
	}
}