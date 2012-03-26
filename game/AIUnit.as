package game {
	import flash.net.URLRequest;
	import flash.events.Event;
	import db.EnemyDatabase;
	
	public class AIUnit extends StatUnit {
		var chaserange:Number;
		static var targets:Array;
		
		public function AIUnit(id) {
			super();
			
			ID = id;
			
			healthPoints = healthMax = EnemyDatabase.getHP(ID);
			setSpeed(EnemyDatabase.getSpeed(ID));
			
			// load swf
			loadSwf();
			
			// TODO: remove event listener
			addEventListener(Event.ENTER_FRAME, runnerAI);
		}
		public static function setTargets(t:Array) {
			targets = t;
		}
		override protected function getSprite() {
			return new URLRequest(EnemyDatabase.getSprite(ID));
		}
		
		// just moves to player if player is in range
		function runnerAI(e:Event) {
			chaserange = 250;
			
			// if close to player
			var min:GameUnit;
			var minDist:Number = 99999999;
			
			for (var i in targets) {
				var un:GameUnit = targets[i];
				var dx = un.x - x;
				var dy = un.y - y;
				var d = dx * dx + dy * dy;
				
				if (d < minDist) {
					min = un;
					minDist = d;
				}
			}
			
			if (minDist < chaserange * chaserange) {
				moveTo(min.x, min.y);
			}
		}
	}
}