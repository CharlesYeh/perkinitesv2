package aiunits {
	import flash.events.Event;
	import flash.geom.Point;
	import flash.net.URLRequest;
	
	import game.Game;
	import game.World;
	
	import db.AbilityDatabase;
	import db.EnemyDatabase;
	import db.dbData.EnemyData;
	
	import game.MapManager;
	
	import units.AIUnit;
	
	public class VendorAI extends AIUnit {
		
		static const spawnRandBase:int = 100;
		static const spawnRandRange:int = 90;
		static const maxEnemies:int = 4;
		static const spawnFrame = 20;
		
		static const enemies:Array = new Array("icecream", "double_icecream");
		
		private var nextSpawn:int = 0;
		private var maxNextSpawn:int = spawnRandBase;
		private var myUnits:Array;
		
		static const shotTime:int = 60;
		private var shotCooldown:int = shotTime;
		
		private var icecreamCount = Game.world.getEnemies().length;
		private var enemyRef = Game.world.getEnemies();
		private var current = 0;
		public function VendorAI(edat:EnemyData) {
			super(edat);
			
			myUnits = new Array();
			
			Game.overlay.ehud.enemyName.text = unitData.name;
			Game.overlay.ehud.HPDisplay.text = unitData.health+"";
			//SCALE IS 2 FOR NOW I'M SORRY WE CAN REVISE IT LATER IF NORMAL HUD REQUIRES A HEALTHBAR
			Game.overlay.ehud.ehpbar.HP.scaleX = 2;
			
			healthbar.visible = false;
			addEventListener(Event.ENTER_FRAME, runnerAI);
		}
		
		override public function takeDamage(dmg:int, attackName:String):void {
			if (!m_enabled) {
				return;
			}
			super.takeDamage(dmg, attackName);
			Game.overlay.ehud.HPDisplay.text = progressData.health+"";
			Game.overlay.ehud.ehpbar.HP.scaleX = progressData.health/unitData.health * 2;
		}
		
		override protected function runnerAI(e:Event) {
			if (!m_enabled) {
				return;
			}
			
			if (progressData.health <= 0) {
				Game.overlay.ehud.visible = false;
				Game.world.clearEnemy(this);
				/*enemyRef = Game.world.getEnemies();
				//remove all enemies - BUG
				for(var i = enemyRef.length - 1; i <= 0; i++) {
					Game.world.clearEnemy(enemyRef[i]);
				}*/
				return;
			}
			
			shotCooldown--;
			if (shotCooldown <= 0) {
				if(current >= icecreamCount) {
					current = 0;
				}
				shotCooldown = shotTime;
				enemyRef[current].castAbility(0, new Point(0, 0));
				
				if(progressData.health <= unitData.health / 2 ) {
					enemyRef[icecreamCount - current - 1].castAbility(0, new Point(0, 0));
					shotCooldown = shotTime/2;
				}
				current++;
			}
			
			if(nextSpawn == 0) {
				castAbility(0, new Point(0, 0));
			}
			//fixing instance in which enemies instantly spawn right after killing AISpawnPoint by adding elseif
			if (nextSpawn <= -1 * spawnFrame && myUnits.length < maxEnemies) {
				// spawn enemy!
				
				var iterate = Math.floor(Math.random() * 3 + 1);
				for(var i = 0; i < iterate; i++) {
					//fix this so that it depends on the direction of the spawn point
					var enemyIndex = Math.floor(Math.random() * enemies.length);
					var u;
					if(i == 0){
						u = MapManager.world.createSpawnEnemy(enemies[enemyIndex], x, y + 100, "down");
					} else if(i == 1){
						u = MapManager.world.createSpawnEnemy(enemies[enemyIndex], x - 64, y, "down");
					} else if(i == 2){
						u = MapManager.world.createSpawnEnemy(enemies[enemyIndex], x + 64, y, "down");
					}
					// replace delete function
					myUnits.push(u);
					u.setDeleteFunction(deleteEnemy);
				}
				nextSpawn = spawnRandBase + Math.floor(Math.random() * spawnRandRange); 
				maxNextSpawn = nextSpawn;
					
			} else if (myUnits.length < maxEnemies) {
				nextSpawn--;
			}
		}
		
		function deleteEnemy(u:AIUnit) {
			myUnits.splice(myUnits.indexOf(u), 1);
		}
		
		public static function getSprite(id:int) {
			return "_sprites/enemy_Vendor.swf";
		}
	}
}