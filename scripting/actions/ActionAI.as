package scripting.actions {
	import game.Game;
	
	import units.AIUnit;
	
	public class ActionAI extends Action {
		
		public var enabled:Boolean; //CHANGE TO ENABLE
		
		override public function parseData(obj:Object):void {
			super.parseData(obj);
			
			enabled = obj.enabled;
		}
		
		override public function act():void {
			super.act();
			
			AIUnit.enabled = enabled;
			
			complete();
		}
	}
}