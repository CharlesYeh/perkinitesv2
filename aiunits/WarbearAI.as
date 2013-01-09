package aiunits {
	import flash.net.URLRequest;
	import flash.events.Event;
	import db.EnemyDatabase;
	import db.AbilityDatabase;
	import units.*;
	import flash.geom.Point;
	import db.dbData.EnemyData;
	
	import game.Game;
	
	/* MINIBOSS WARBEAR AI
	 * if within chase range, chases
	 * if within ability range, uses ability
	 */
	public class WarbearAI extends AIUnit {
		
		var wait; //how long it waits after an attack
		var angry:Boolean;
		
		var shotwait; //how long it waits to perform the shot ability
		public function WarbearAI(edat:EnemyData) {
			super(edat);
			
			angry = false;
			shotwait = 24 * 8; //8 seconds before shot attack
			removeChild(healthbar);
			
			Game.overlay.ehud.HPDisplay.text = unitData.health+"";
			Game.overlay.ehud.ehpbar.HP.scaleX = 1;
		}
		
		override public function takeDamage(dmg:int):void {
			super.takeDamage(dmg);
			Game.overlay.ehud.HPDisplay.text = progressData.health+"";
			Game.overlay.ehud.ehpbar.HP.scaleX = progressData.health/unitData.health;
		}
		// just moves to player if player is in range then attack
		override protected function runnerAI(e:Event) {
			if (!m_enabled) {
				return;
			}
			
			if (progressData.health <= 0) 
				Game.world.clearEnemy(this);
				
			if(wait > 0){
				wait--;
				return;
			}
			
			if(!angry && progressData.health <= unitData.health/2){
				angry = true;
				setSpeed(190);
				trace("War Bear is angry now.");
			}
			if(angry){
				shotwait--;
			}
			var atkRange = unitData.abilities[0].range;
			
			var target:StatUnit = getCloserPlayer();
			var tp:Point = new Point(target.x, target.y);
			
			var dist:Number = getDistance(target);
			if (dist < atkRange) {
				// attack
				castAbility(0, tp);
				wait = 60;
				if(angry){
					wait = 30;
				}
			}
			else {
				chaseTarget(target, 250);
			}
			
			if(shotwait <= 0){
				shotwait = 24 * 8;
				var rand = Math.floor(Math.random()*2+1);
				castAbility(rand, tp);
			}
		}
	}
}