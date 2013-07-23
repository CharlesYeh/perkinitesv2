package scripting.actions {
	
	import game.Game;
	
	public class ActionNarrator extends Action {
		public var toggle;
		
		public var message:String;
		private var m_time:int;
		
		override public function parseData(obj:Object):void {
			super.parseData(obj);
			
			message = obj.message;
			if (obj.toggle != null) {
				toggle = obj.toggle;
			}
		}
		
		override public function update():Boolean {
			m_time--;
			if (m_time <= 0 || super.update()) {
				Game.overlay.narrator.hideText(this);
			}
			
			return super.update();
		}
		
		override public function act():void {
			if (toggle != null) {
				Game.overlay.narrator.setToggle(toggle);				
			}
			Game.overlay.narrator.showText(message);
			Game.overlay.narrator.setAction(this);
			m_time = time;
		}
	}
}