package units {
	import flash.utils.getDefinitionByName;
	import flash.net.URLRequest;
	import flash.events.Event;
	
	import db.EnemyDatabase;
	import db.dbData.EnemyData;
	
	import aiunits.*;
	
	import game.Game;
	
	public class AIUnit extends StatUnit {
		var chaserange:Number;
		static var targets:Array;
		
		public function AIUnit(id) {
			super();
			
			ID = id;
			
			healthPoints = unitData.health;
			setSpeed(unitData.speed);
			
			// load swf
			loadSwf();
			
			// TODO: remove event listener
			addEventListener(Event.ENTER_FRAME, runnerAI);
		}
		public static function createAIUnit(id:String) {
			var edat:EnemyData = Game.dbEnemy.get
			var AIClass:Class = getDefinitionByName("aiunits." + edat.ai) as Class;
			return new AIClass(edat);
		}
		
		override protected function deleteSelf() {
			super.deleteSelf();
			
			removeEventListener(Event.ENTER_FRAME, runnerAI);
		}
		override protected function getSprite() {
			return new URLRequest(EnemyDatabase.getSprite(ID));
		}
		
		// just moves to player if player is in range
		protected function runnerAI(e:Event) {
			if (healthPoints < 0)
				deleteSelf();
			
			chaserange = 250;
			chasePlayer(chaserange);
		}
		protected function getCloserPlayer():StatUnit {
			var min:StatUnit;
			var minDist:Number = 99999999;
			
			for (var i in targets) {
				var un:StatUnit = targets[i];
				var dx = un.x - x;
				var dy = un.y - y;
				var d = dx * dx + dy * dy;
				
				if (d < minDist) {
					min = un;
					minDist = d;
				}
			}
			
			return min;
		}
		protected function getDistance(g:GameUnit) {
			var dx = g.x - x;
			var dy = g.y - y;
			return Math.sqrt(dx * dx + dy * dy);
		}
		protected function chasePlayer(chaserange:int) {
			// if close to player
			var target:GameUnit = getCloserPlayer();
			chaseTarget(target, chaserange);
		}
		protected function chaseTarget(target:GameUnit, chaserange:int) {
			var dist:Number = getDistance(target);
			
			if (dist < chaserange) {
				moveTo(target.x, target.y);
			}
		}
	}
}