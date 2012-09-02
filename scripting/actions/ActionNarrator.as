package scripting.actions {
	
	import game.Game;
	
	public class ActionNarrator extends Action {
		
		public var message:String;
		private var m_time:int;
		
		override public function parseData(obj:Object):void {
			super.parseData(obj);
			
			message = obj.message;
		}
		
		override public function update():Boolean {
			m_time--;
			if (m_time <= 0) {
				Game.overlay.narrator.hideText(this);
			}
			
			return super.update();
		}
		
		override public function act():void {
			Game.overlay.narrator.showText(message);
			m_time = time;
			trace(time);
		}
	}
}