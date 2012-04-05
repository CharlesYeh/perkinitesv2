package aiunits {
	import flash.net.URLRequest;
	import flash.events.Event;
	import db.EnemyDatabase;
	import db.AbilityDatabase;
	import game.*;
	import flash.geom.Point;
	
	/* BASIC AI ENEMY
	 * if within chase range, chases
	 * if within ability range, uses ability
	 */
	public class AISpawnPoint extends StatUnit {
		
		static const START_ID:int = 5000;
		static const healths = new Array(300, 500, 800);
		static const spawnRandBase = new Array(300, 340, 390);
		static const spawnRandRange = new Array(90, 150, 230);
		
		var nextSpawn:int;
		var myUnits:Array;
		
		public function AISpawnPoint(id:int) {
			super();
			
			ID = id;
			
			healthPoints = healthMax = healths[id];
			drawHealthbar();
			
			nextSpawn = 0;
			myUnits = new Array();
			
			addEventListener(Event.ENTER_FRAME, aiSpawner);
		}
		function aiSpawner(e:Event) {
			if (healthPoints <= 0)
				deleteSelf();
			
			if (nextSpawn <= 0 && myUnits.length < 3) {
				// spawn enemy!
				
				var u = MapManager.createEnemy(0, x, y);
				// replace delete function
				u.setDeleteFunction(deleteEnemy);
				myUnits.push(u);
				
				nextSpawn = spawnRandBase[ID] + Math.floor(Math.random() * spawnRandRange[ID]);
			}
			else {
				nextSpawn--;
			}
		}
		function deleteEnemy(u:AIUnit) {
			myUnits.splice(myUnits.indexOf(u), 1);
			MapManager.deleteEnemy(u);
		}
		override protected function deleteSelf() {
			super.deleteSelf();
			
			removeEventListener(Event.ENTER_FRAME, aiSpawner);
		}
		public static function getSprite(id:int) {
			return "_sprites/enemy_Spawn_Point.swf";
		}
	}
}