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
	
	public class WristonSpawnPoint extends AIUnit {
		
		static const spawnRandBase:int = 200;
		static const spawnRandRange:int = 90;
		static const maxEnemies:int = 3;
		
		static const enemies:Array = new Array("drunk_fratguy", "drunkguy");
		static const directions:Array = new Array("right", "up", "left", "down");
		
		private var nextSpawn:int = 0;
		private var maxNextSpawn:int = spawnRandBase;
		private var myUnits:Array;
		
		public function WristonSpawnPoint(edat:EnemyData) {
			super(edat);
			
			myUnits = new Array();
			
			addEventListener(Event.ENTER_FRAME, runnerAI);
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
			if (!m_enabled) {
				return;
			}
			//fixing instance in which enemies instantly spawn right after killing AISpawnPoint by adding elseif
			drawHealthbar();
			if (nextSpawn <= 0 && myUnits.length < maxEnemies) {
				// spawn enemy!
				var enemyIndex = Math.floor(Math.random() * enemies.length);
				var directionIndex = Math.floor(Math.random() * directions.length);
				
				//fix this so that it depends on the direction of the spawn point
				var u = MapManager.world.createSpawnEnemy(enemies[enemyIndex], x, y + 5, directions[directionIndex]);
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