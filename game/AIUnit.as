package game {
	import flash.events.Event;
	
	public class AIUnit extends StatUnit{
		public function AIUnit(id) {
			super();
			
			ID = id;
			
			// TODO: remove event listener
			addEventListener(Event.ENTER_FRAME, runnerAI);
		}
		override protected function getSprite() {
			return new URLRequest(CharacterDatabase.getCharSprite(id));
		}
		function runnerAI(e:Event) {
			
		}
	}
}