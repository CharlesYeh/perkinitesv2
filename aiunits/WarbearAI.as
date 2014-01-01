﻿package aiunits {
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
	 
	 
	 /**
	 	starting state:
		 1. walk to player
		 2. if close enough, melee attack
		 angry state:
		 1. walk faster at player
		 2. every 4-8 seconds, pause then shoot skillshots. I think these skillshots should be in a dodgeable pattern, with screen-wide range.
		 3. if close enough, melee attack
		 */
		 
	public class WarbearAI extends AIUnit {
		
		var wait; //how long it waits after an attack
		var angry:Boolean;
		
		var shotwait; //how long it waits to perform the shot ability
		public function WarbearAI(edat:EnemyData) {
			super(edat);
			
			angry = false;
			shotwait = 24 * 4; //4 seconds before shot attack
			healthbar.visible = false;
			
			//Game.overlay.ehud.visible = true;
			Game.overlay.ehud.enemyName.text = unitData.name;
			Game.overlay.ehud.HPDisplay.text = unitData.health+"";
			//SCALE IS 2 FOR NOW I'M SORRY WE CAN REVISE IT LATER IF NORMAL HUD REQUIRES A HEALTHBAR
			Game.overlay.ehud.ehpbar.HP.scaleX = 2;
		}
		
		override public function takeDamage(dmg:int, attackName:String):void {
			if (!m_enabled) {
				return;
			}
			
			if(attackName == "PEACE<3BEAM") {
				dmg = 100000000000;   
			}
			super.takeDamage(dmg, attackName);
			Game.overlay.ehud.HPDisplay.text = progressData.health+"";
			Game.overlay.ehud.ehpbar.HP.scaleX = progressData.health/unitData.health * 2;
		}
		// just moves to player if player is in range then attack
		override protected function runnerAI(e:Event) {
			if (!m_enabled) {
				return;
			}
			
			if (progressData.health <= 0) {
				Game.overlay.ehud.visible = false;
				Game.world.clearEnemy(this);
			}
				
				
			if(angry){
				shotwait--;
			}
			
			if(wait > 0){
				wait--;
				return;
			}
			
			
			
			
			if(!angry && progressData.health <= unitData.health/2){
				angry = true;
				setSpeed(190);
				//make a sound here
			}
			var atkRange = unitData.abilities[0].range;
			
			var target:StatUnit = getCloserPlayer();
			var tp:Point = new Point(target.x, target.y);
			
			var dist:Number = getDistance(target);
			if (dist < atkRange) {
				// attack
				castAbility(0, tp);
				
				if(!angry){
					wait = 50;
					path = new Array();
				}
				else{
					wait = 30;
				}
			}
			else {
				chaseTarget(target, 1000);
			}
			
			if(shotwait <= 0){
				shotwait = 24 * 4;
				var rand = Math.floor(Math.random()*2+1);
				castAbility(rand, tp);
			}
		}
	}
}