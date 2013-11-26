package aiunits {
	import flash.events.Event;
	import flash.geom.Point;
	import flash.net.URLRequest;
	import game.World;
	
	import db.AbilityDatabase;
	import db.EnemyDatabase;
	import db.dbData.EnemyData;
	
	import game.Game;
	import game.MapManager;
	
	import units.AIUnit;
	
	public class RattySpawnPoint extends AIUnit {
		
		static const spawnRandBase:int = 200;
		static const spawnRandRange:int = 90;
		static const maxEnemies:int = Math.floor(Math.random() * 1 + 2);
		
		static const enemies:Array = new Array("icecream", "chocochip_cookie", "fries", "o_rings");
		static const directions:Array = new Array("right", "up", "left", "down");
		
		private var nextSpawn:int = 0;
		private var maxNextSpawn:int = spawnRandBase;
		private var myUnits:Array;
		
		public function RattySpawnPoint(edat:EnemyData) {
			super(edat);
			
			myUnits = new Array();
			healthbar.visible = false;
			
			addEventListener(Event.ENTER_FRAME, runnerAI);
		}
		
		override protected function runnerAI(e:Event) {
			//fixing instance in which enemies instantly spawn right after killing AISpawnPoint by adding elseif
			
			if (nextSpawn <= 0 && myUnits.length < maxEnemies && getDistance(Game.team[0]) > 320) {
				// spawn enemy!
				var enemyIndex = Math.floor(Math.random() * enemies.length);
				var directionIndex = Math.floor(Math.random() * directions.length);
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