package game {
	import flash.events.Event;
	import db.EnemyDatabase;
	
	public class AIUnit extends StatUnit{
		public function AIUnit(id) {
			super();
			
			ID = id;
			
			// load swf
			loadSwf();
			
			// TODO: remove event listener
			addEventListener(Event.ENTER_FRAME, runnerAI);
		}
		override protected function getSprite() {
			return new URLRequest(EnemyDatabase.getEnemySprite(ID));
		}
		function runnerAI(e:Event) {
			
		}
	}
}