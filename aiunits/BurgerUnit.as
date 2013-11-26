package aiunits {
	import game.Game;
	import flash.net.URLRequest;
	import flash.events.Event;
	import db.EnemyDatabase;
	import db.AbilityDatabase;
	import units.*;
	import flash.geom.Point;
	import db.dbData.EnemyData;
	
	/* BASIC AI ENEMY
	 * if within ability range, uses ability
	 * begin casting
	 * pick a burger
	 * shoot ability
	 */
	public class BurgerUnit extends AIUnit {
		
		private var searchCooldown:int;
		private const MAX_SEARCH_COOLDOWN:int =  10;
		private const RAND_SEARCH_RANGE:int = 6;
		
		private const CHOOSE_DURATION:int = 5;
		private var animCooldown:int;
		private var selectedAbility:int;
		public function BurgerUnit(edat:EnemyData) {
			super(edat);
			animCooldown = 0;
			cooldowns[0] = 0; //temporary
			selectedAbility = 0;
			searchCooldown = (int)(Math.random() * RAND_SEARCH_RANGE);
		}
		
		override public function endAbility() {
			usingAbility = false;
			beginAnimation("standing");
		}
		// just moves to player if player is in range then attack
		override protected function runnerAI(e:Event) {
			if (!m_enabled) {
				return;
			}
			
			if (progressData.health <= 0) 
				Game.world.clearEnemy(this);
				
			if (usingAbility) {
				return;
			}
			if (usingAnimation) {
				animCooldown--;
				if (animLabel == "beginning" && animCooldown <= 0) {
					beginAnimation("choosing");
					var rand = Math.floor(Math.random() * 3);
					animCooldown = CHOOSE_DURATION * (rand + 1) - 1;
					selectedAbility = rand;
				} else if (animLabel == "choosing" && animCooldown <= 0) {
					var target:StatUnit = getCloserPlayer();
					var tp:Point = new Point(target.x, target.y);					
					castAbility(selectedAbility, tp);
				}
				return;
			}
			
			var atkRange = unitData.abilities[0].range * 0.9;
			
			var target:StatUnit = getCloserPlayer();
			var dist:Number = getDistance(target);
			if (dist < atkRange) {
				// attack
				if(cooldowns[0] <= 0){
					beginAnimation("beginning");
					animCooldown = CHOOSE_DURATION - 1;
				}
				else{
					path = new Array();
				}
			}
			else {
				if (searchCooldown <= 0) {
					chaseTarget(target, 250);
					searchCooldown = MAX_SEARCH_COOLDOWN + (int)(Math.random() * RAND_SEARCH_RANGE);
				} else {
					searchCooldown--;
				}
			}
		}
	}
}