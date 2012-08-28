package scripting.actions {
	public class ActionWait extends Action{
		
		private var m_time:int;
		
		override public function parseData(obj:Object):void {
			super.parseData(obj);
		}
		
		override public function update():Boolean {
			m_time--;
			if (m_time <= 0) {
				complete();
			}
			
			return super.update();
		}
		
		override public function act():void {
			m_time = time;
		}
	}
}