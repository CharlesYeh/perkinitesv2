package aiunits {
	import flash.events.Event;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.net.URLRequest;
	
	import db.EnemyDatabase;
	import db.AbilityDatabase;
	import db.dbData.EnemyData;
	import db.dbData.MapCharacterData;
	
	import game.Game;
	import game.GameConstants;
	import game.MapManager;
	
	import units.AIUnit;
	import units.StatUnit;
	
	/* SOCORDIA AI
	 * until you get the spicy quesadilla, she'll infinitely grow XXX kcal
	 * she should use kcal to activate her abilities
	 * 
	 * when you get the spicy quesadilla, you can decrease her kcal so that she can't cast abilities as often
	 * when she hits << the minimum needed, she'll temporarily spawn more kcal
	 */
	 
		 
	public class BossSocordiaAI extends AIUnit {
		
		/** SPAWN **/
		static const spawnRandBase:int = 360;
		static const spawnRandRange:int = 90;
		static const maxEnemies:int = 4;
		
		
		private var nextSpawn:int = 0;
		private var myUnits:Array = new Array();
		
		private var spawning:Boolean = false;

		/** MELEE **/
		
		var wait:int; //how long it waits after an attack
		const MAX_WAIT:int = 120;
		const MAX_OVERDRIVE_WAIT:int = 80;
		var numMelee:int = 0;
		const MAX_MELEE:int = 2;
		
		/** RANGE **/
		
		/** DROP DOWN **/

		/** OTHER **/
		
		var glowHit = new GlowFilter(0xFFFF00, 0, 20, 20, 1, 10, true, false);
		
		var quesadilla:Boolean = false;
		var overdrive:Boolean = false;
		
		public function BossSocordiaAI(edat:EnemyData) {
			super(edat);
			trace(quesadilla);
			
			wait = MAX_WAIT;
			
			healthbar.visible = false;
			
			Game.overlay.ehud.enemyName.text = unitData.name;
			Game.overlay.ehud.HPDisplay.text = unitData.health+"";	
			//SCALE IS 2 FOR NOW I'M SORRY WE CAN REVISE IT LATER IF NORMAL HUD REQUIRES A HEALTHBAR
			Game.overlay.ehud.ehpbar.HP.scaleX = 2;
			Game.overlay.ehud.gotoAndStop("socordia_invulnerable");
		}
		
		override public function takeDamage(dmg:int):void {
			if (!m_enabled) {
				return;
			}
			
			if (quesadilla) {
				var prevHealth = progressData.health;
				super.takeDamage(dmg);
				if (prevHealth > 250) {
					progressData.health = Math.max(250, progressData.health);
					if(progressData.health == 250) {
						startOverdrive();						
					}
				} 
				Game.overlay.ehud.HPDisplay.text = progressData.health+"";
				Game.overlay.ehud.ehpbar.HP.scaleX = progressData.health/unitData.health * 2;	
			} else {
				glowHit.alpha = 1.0;
				//this.swf.filters = [glowHit];
			}
		}
		
		override protected function runnerAI(e:Event) {
			if (!m_enabled) {
				return;
			}
			
			if (!quesadilla && Game.playerProgress.hasUnlockedItem("Quesadilla")) {
				quesadilla = true;
				Game.overlay.ehud.gotoAndStop("socordia_vulnerable");
			}
			
			if (progressData.health <= 0) {
				Game.overlay.ehud.visible = false;
				Game.world.clearEnemy(this);
			}
			
			
			update();
		}
		
		function update() {
			glowHit.alpha-=0.1;
			//this.swf.filters = [glowHit];
			
			if (overdrive) {
				overdriveState();
			} else {
				startingState();
			}
		}

		function startingState():void {
			castAbilities();	
		}		
		
		function overdriveState():void {
			castAbilities();
		}
		
		function startOverdrive():void {
			overdrive = true;
			Game.overlay.ehud.gotoAndStop("socordia_overdrive");
		}
		
		function castAbilities():void {
			var atkRange;
			
			var target:StatUnit;
			var tp:Point;
			
			var dist:Number;
			
			nextSpawn--;
			wait--;
						
			if (usingAbility) {
				return;
			}
			
			if (spawning && nextSpawn <= 14) {
				for (var i = 0; i < 2; i++){
					var u = MapManager.world.createSpawnEnemy("fries", x, y, "down");
					// replace delete function
					myUnits.push(u);
					u.setDeleteFunction(deleteEnemy);
				}
				spawning = false;
				nextSpawn = spawnRandBase + Math.floor(Math.random() * spawnRandRange); 				
			} else if (nextSpawn <= 0) {
				nextSpawn = 45;
				castAbility(0, new Point(x, y));
				spawning = true;
			} else {
				target = getCloserPlayer();
				tp = new Point(target.x, target.y);								
				if (wait <= 0) {
					atkRange = unitData.abilities[2].range;
					
					dist = getDistance(target);
					if (dist < atkRange + GameConstants.TILE_SIZE) {
						// attack
						if (numMelee < MAX_MELEE) {
							castAbility(2, tp);
							wait = (overdrive)? MAX_OVERDRIVE_WAIT : MAX_WAIT;		
							numMelee++;
							return;							
						} else {
							numMelee = 0;
						}
					}			
					
					wait = (overdrive)? MAX_OVERDRIVE_WAIT : MAX_WAIT;
					var rand = (int)(Math.random() * 2);
					if (rand == 0 || progressData.health > 250) {  
						castAbility(1, tp);
					} else {
						castAbility(3, tp);
					}						
				} 
			}
		}

		override public function turnTo(point) {
			var radian = Math.atan2(point.y - y, point.x - x);
			moveDir = 3;
			
			return radian;
		}

		function deleteEnemy(u:AIUnit) {
			myUnits.splice(myUnits.indexOf(u), 1);
		}
	}
}