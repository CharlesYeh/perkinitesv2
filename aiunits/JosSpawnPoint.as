package aiunits {
	import flash.events.Event;
	import flash.geom.Point;
	import flash.net.URLRequest;
	import game.World;
	
	import db.AbilityDatabase;
	import db.EnemyDatabase;
	import db.dbData.EnemyData;
	
	import game.MapManager;
	
	import units.AIUnit;
	
	/* AI SPAWN POINT
	 * Generates a new enemy every so often
	 */
	public class JosSpawnPoint extends AIUnit {
		
		static const START_ID:int = 5000;
		static const spawnRandBase:int = 100;
		static const spawnRandRange:int = 90;
		static const maxEnemies:int = 2;
		
		static const enemies:Array = new Array("fries", "o_rings", "m_stick", "burger");
		static const directions:Array = new Array("right", "up", "left", "down");
		
		private var nextSpawn:int = 0;
		private var maxNextSpawn:int = spawnRandBase;
		private var myUnits:Array;
		
		public function JosSpawnPoint(edat:EnemyData) {
			super(edat);
			
			myUnits = new Array();
			
		}
		
		override protected function drawHealthbar() {
			//prevent drawing healthbar after death
			if(healthbar != null){
				var WIDTH = 50;
				var sx = -WIDTH/2;
				
				healthbar.graphics.clear();
				healthbar.graphics.lineStyle(1, 0);
				healthbar.graphics.drawRect(sx, 10, WIDTH, 5);
				
				healthbar.graphics.beginFill(0x333333, .7);
				healthbar.graphics.drawRect(sx, 10, WIDTH * (maxNextSpawn - nextSpawn) / maxNextSpawn, 5);
				healthbar.graphics.endFill();
			}
		}
		
		override protected function runnerAI(e:Event) {
			//fixing instance in which enemies instantly spawn right after killing AISpawnPoint by adding elseif
			drawHealthbar();
			if (nextSpawn <= 0 && myUnits.length < maxEnemies) {
				// spawn enemy!
				var enemyIndex = Math.floor(Math.random() * enemies.length);
				var directionIndex = Math.floor(Math.random() * directions.length);
				var u = MapManager.world.createSpawnEnemy(enemies[enemyIndex], x, y, directions[directionIndex]);
				// replace delete function
				myUnits.push(u);
				u.setDeleteFunction(deleteEnemy);
				nextSpawn = spawnRandBase + Math.floor(Math.random() * spawnRandRange); 
				maxNextSpawn = nextSpawn;
			} else if (myUnits.length < maxEnemies) {
				nextSpawn--;
			}
		}
		
		function deleteEnemy(u:AIUnit) {
			myUnits.splice(myUnits.indexOf(u), 1);
		}
		
		override public function takeDamage(dmg:int):void {
			return;
		}
		
		public static function getSprite(id:int) {
			return "_sprites/enemy_Spawn_Point.swf";
		}
	}
}