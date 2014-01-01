package aiunits {
	import flash.net.URLRequest;
	import flash.events.Event;
	import db.EnemyDatabase;
	import db.AbilityDatabase;
	import units.*;
	import flash.geom.Point;
	import db.dbData.EnemyData;
	
	import game.Game;
	import game.GameConstants;
	import db.dbData.MapCharacterData;
	
	/* GULA AI
	 * if within chase range, chase
	 * if within ability range, use consume
	 
	 * SIMPLIFY THIS MORE
	 */
	 
	 /**
	 	starting state:
		1. run to player
		2. if close enough, melee attack (do not turn around if player at different direction now)
		3. if attack any enemies, destroy them and reduce hunger. if attack players, reduce hunger.
		4. pause
		5. repeat
		6. randomly shoot ability 2

		not hungry state (when hunger reaches 0):
		1. pause until 50-75 damage is dealt to it
		2. randomly shoot ability 3
		
		half health state?:
		1. change the game mode to pacman
		2. for thirty seconds, play pacman. if player gets hit, end pacman and player loses 40 health
		3. player cannot die this way though
		*/
		 
	public class BossGulaAI extends AIUnit {
		
		var wait:int; //how long it waits after an attack
		
		public static var HUNGER:Number = 10000; //hunger level
		
		var shooter:int; //cooldown of shooting
		const MAX_SHOOTER:int = 240;
		
		var duration:int; //how long this unit shoots at things
		
		var threshold:int; //when this goes less than 0, return back to hunger
		const MAX_THRESHOLD:int = 75;
		
		public static var secondHealth:int = 0; //when you go half health, record the health here and then teleport to the next screen to start drive mode
		
		public function BossGulaAI(edat:EnemyData) {
			super(edat);
			
			BossGulaAI.HUNGER = 10000;
			shooter = MAX_SHOOTER;
			
			duration = 0;
			
			threshold = MAX_THRESHOLD;
			
			healthbar.visible = false;
			healthbar.y = 40;
			
			//Game.overlay.ehud.visible = true;
			Game.overlay.ehud.enemyName.text = unitData.name;
			Game.overlay.ehud.HPDisplay.text = unitData.health+"";
			//SCALE IS 2 FOR NOW I'M SORRY WE CAN REVISE IT LATER IF NORMAL HUD REQUIRES A HEALTHBAR
			Game.overlay.ehud.ehpbar.HP.scaleX = 2;
			Game.overlay.ehud.gotoAndStop("gula");
			
			Game.overlay.ehud.hungerDisplay.text = 
				Math.floor(BossGulaAI.HUNGER/100) + "." + (BossGulaAI.HUNGER % 100)+"%";
		}
		
		override public function takeDamage(dmg:int, attackName:String):void {
			if (!m_enabled) {
				return;
			}
			super.takeDamage(dmg, attackName);
			
			if(BossGulaAI.HUNGER <= 0 && threshold > 0) {
				threshold -= dmg;
			}
			drawHealthbar();
			Game.overlay.ehud.HPDisplay.text = progressData.health+"";
			Game.overlay.ehud.ehpbar.HP.scaleX = progressData.health/unitData.health * 2;
		}
		
		override protected function drawHealthbar() {
			//prevent drawing healthbar after death
			if(healthbar != null && threshold >= 0){
				var WIDTH = 50;
				var sx = -WIDTH/2;
				
				healthbar.graphics.clear();
				healthbar.graphics.lineStyle(1, 0);
				healthbar.graphics.drawRect(sx, 10, WIDTH, 5);
				
				healthbar.graphics.beginFill(0x33FF33, .7);
				healthbar.graphics.drawRect(sx, 10, WIDTH * threshold / MAX_THRESHOLD, 5);
				healthbar.graphics.endFill();
			}
		}
		
		override protected function runnerAI(e:Event) {
			if (!m_enabled) {
				return;
			}
			
			if (progressData.health <= 0) {
				Game.overlay.ehud.visible = false;
				Game.world.clearEnemy(this);
				return;
			}
			
			wait--;
			if(BossGulaAI.HUNGER <= 0) {
				fullState();
			} else {
				startingState();
			}
			
			update();
		}
		
		function update(){
			if(BossGulaAI.HUNGER <= 0) {
				healthbar.visible = true;
				BossGulaAI.HUNGER = 0;
			} 
			if(threshold <= 0 && BossGulaAI.HUNGER  < 10000) {
				BossGulaAI.HUNGER  += 150;
				threshold = 0;
			} else if(threshold <= 0 && BossGulaAI.HUNGER  >= 10000) {
				BossGulaAI.HUNGER = 10000;
				threshold = MAX_THRESHOLD;
				healthbar.visible = false;
			}			

			Game.overlay.ehud.hungerDisplay.text = 
				Math.floor(BossGulaAI.HUNGER/100) + "." + (BossGulaAI.HUNGER % 100)+"%";

		}
		function startingState(){
			var atkRange;
			
			var target:StatUnit;
			var tp:Point;
			
			var dist:Number;
			
			atkRange = unitData.abilities[0].range;
				
			target = getCloserPlayer();
			tp = new Point(target.x, target.y);
				
			dist = getDistance(target);
			shooter--;
			if (shooter > 0 && wait <= 0 && threshold > 0) {
				// attack
				castAbility(0, tp);
				
				wait = 24 * 2.5;
			} else if(shooter <= 0 && wait <= 0 && threshold > 0){
				target = getCloserPlayer();
				tp = new Point(target.x, target.y);
				
				castAbility(1, tp);
				wait = 72;
				path = new Array();
				shooter = MAX_SHOOTER;
			} else {
				chaseTarget(target, 1000);
			}
		}
		
		function fullState() {
			path = new Array();
			if(wait <= 0) {
				var target = getCloserPlayer();
				var tp = new Point(target.x, target.y);
				
				castAbility(2, tp); 
				if (progressData.health/unitData.health <= 1/2) {
					wait = 24 * 2;
				} else {
					wait = 24 * 4;	
				}
			}
		}
	}
}