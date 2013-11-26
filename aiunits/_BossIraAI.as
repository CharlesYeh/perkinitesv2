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
	
	/* IRA AI
	 * if within chase range, chases
	 * if within ability range, uses ability
	 
	 * SIMPLIFY THIS MORE
	 */
	 
	 /**
	 	starting state:
		1. run to player
		2. if close enough, melee attack (do not turn around if player at different direction now)
		3. pause
		4. after melee attack/running for five seconds, randomly go to a point and shoot until path = 0
		5. if the players are nearby, do another melee attack
		
		anger helps speed up Ira (from 150 -> 200 @ 100 anger)
		
		angry state (when anger reaches 100):
		1. rages and becomes invulnerable
		2. advances towards player and casts ability2, slowly decreases anger level
		
		at half-health
		changes map
		starting state:
		1. run faster to player
		2. if close enough, melee attack (do not turn around if player at different direction now)
		
		anger helps speed up Ira (from 200 -> 240 @ 500+ anger)
		
		angry state (now reaches 999):
		1. goes to the middle of the screen and  casts ability4, slowly decreases anger level to 100

		
		*/
		
 	/**
	 	Perkinite Secret Skill: TELEPHONE
		You can telephone either DPS or BUMP.
		Press Shift to activate Telephone when Ira gets 100 angry/999 angry.
		Selecting DPS will decrease anger slowly but deal damage.
		Selecting BUMP will decrease anger quickly but deal no damage.
		
		*/
			
		 
	public class BossIraAI extends AIUnit {
		
		var wait:int; //how long it waits after an attack
		var anger:int; //anger level - when at 100, creates 
		var angerDelay:int; //how many ticks it takes to raise anger
		var maxAngerDelay:int;
		var angerInc:int; //what the increment of anger is
		var angry:Boolean;
		
		var float:Boolean;
		var chase:int; //how long this unit has chased the player
		
		var shotwait; //how long it waits to perform the shot ability
		public function BossIraAI(edat:EnemyData) {
			super(edat);
			
			wait = 0;
			anger = 10;
			angerDelay = 18;
			maxAngerDelay = 18;
			angerInc = 2;
			angry = false;
			
			float = false;
			chase = 0;
			shotwait = 0; //4 seconds before shot attack
			healthbar.visible = false;
			
			Game.overlay.ehud.visible = true;
			Game.overlay.ehud.enemyName.text = unitData.name;
			Game.overlay.ehud.HPDisplay.text = unitData.health+"";
			//SCALE IS 2 FOR NOW I'M SORRY WE CAN REVISE IT LATER IF NORMAL HUD REQUIRES A HEALTHBAR
			Game.overlay.ehud.ehpbar.HP.scaleX = 2;
			Game.overlay.ehud.gotoAndStop("ira");
			
			Game.overlay.ehud.angerDisplay.text = anger+"";
			Game.overlay.ehud.speedDisplay.text = this.speed+"";
		}
		
		override public function takeDamage(dmg:int):void {
			super.takeDamage(dmg);
			Game.overlay.ehud.HPDisplay.text = progressData.health+"";
			Game.overlay.ehud.ehpbar.HP.scaleX = progressData.health/unitData.health * 2;
			if(progressData.health <= unitData.health/2){
				anger = Math.max(Math.min(999, anger + 26), 100);	
			}
			else{
				anger = Math.min(100, anger + 5);					
			}
		}
		
		override protected function runnerAI(e:Event) {
			if (!m_enabled) {
				return;
			}
			
			if (progressData.health <= 0) {
				Game.overlay.ehud.visible = false;
				Game.world.clearEnemy(this);
			}
			
			if(wait > 0){
				wait--;
				update();
				return;
			}
		
			if(progressData.health <= unitData.health/2){
				maxAngerDelay = 12;
				angerInc = 11;
				if(angry){
					secAngryState();
				}
				else{
					secStartingState();
				}				
			}
			else{
				if(angry){
					angryState();
				}
				else{
					startingState();
				}
				
			}
			
			update();
		}
		
		public function update(){
			if(!angry){
				if(progressData.health <= unitData.health/2){
					setSpeed(Math.min(240, Math.floor(200 + (anger - 100)/400.0 * 40.0))); //bound from 200-240
				}
				else{
					setSpeed(150 + Math.floor(anger/100.0 * 50.0));	
				}				
			}
			
			Game.overlay.ehud.angerDisplay.text = anger+"";
			Game.overlay.ehud.speedDisplay.text = this.speed+"";
		}
		public function startingState(){
			var atkRange;
			
			var target:StatUnit;
			var tp:Point;
			
			var dist:Number;
			
			if(!float && chase >= 24 * 5){
				//(1,3), (23, 16)
				//1 - 23, 3 - 16
				float = true;
				var gx;
				var gy;
				if((x + 0.5)/ GameConstants.TILE_SIZE < 12){
					gx = (x + 0.5)/ GameConstants.TILE_SIZE + 10;
				}
				else{
					gx = (x + 0.5)/ GameConstants.TILE_SIZE - 10;
				}
				if((y + 0.5)/ GameConstants.TILE_SIZE < 10){
					gy = (y + 0.5)/ GameConstants.TILE_SIZE + 6;
				}
				else{
					gy = (y + 0.5)/ GameConstants.TILE_SIZE - 6;
				}
				var gp:Point = new Point(gx, gy);
				
				this.moveTo((gx + 0.5) * GameConstants.TILE_SIZE, (gy + 0.5)  * GameConstants.TILE_SIZE);
			}
			else if(float){
				if(path.length == 0){
					float = false;
					chase = 0;
					atkRange = unitData.abilities[0].range;
				
					target = getCloserPlayer();
					tp = new Point(target.x, target.y);
					
					dist = getDistance(target);
					if (dist < atkRange) {
						// attack
						castAbility(0, tp);
					}	
					wait = 72;
					path = new Array();
				}
				else{
					//shoot dark bullets
					chase++;
					if(chase % 18 == 0){
						atkRange = unitData.abilities[0].range;
				
						target = getCloserPlayer();
						tp = new Point(target.x, target.y);
						castAbility(2, tp);
					}
				}
			}
			else{
				atkRange = unitData.abilities[0].range;
				
				target = getCloserPlayer();
				tp = new Point(target.x, target.y);
				
				dist = getDistance(target);
				if (dist < atkRange) {
					// attack
					castAbility(0, tp);
					
					wait = 50;
					path = new Array();
					chase = 9999;
				}
				else {
					chaseTarget(target, 1000);
					chase++;
					if(chase >= 24 * 5){
						wait = 50;
					}
				}

			}			
			
			
			angerDelay--;
			if(angerDelay <= 0){
				angerDelay = maxAngerDelay;
				anger = Math.min(100, anger + angerInc);					
			}			
			
			if(anger == 100){
				angry = true;
				setSpeed(150 + Math.floor(anger/100.0 * 50.0));	
			}
		}
		public function angryState(){
			setSpeed(240);

				
			var atkRange;
			
			var target:StatUnit;
			var tp:Point;
			
			var dist:Number;	
			
			atkRange = unitData.abilities[0].range;
				
			target = getCloserPlayer();
			tp = new Point(target.x, target.y);
				
			dist = getDistance(target);
			
			chaseTarget(target, 1000);
			shotwait++;
			if (dist < atkRange || shotwait == 70){
				castAbility(1, tp);
				shotwait = 0;
			}
			
			angerDelay--;
			if(angerDelay <= 0){
				angerDelay = maxAngerDelay;
				anger = Math.min(100, anger - angerInc*2);
				
			}						
			if(anger <= 0){
				//when done
				wait = 96;
				shotwait = 0;
				angry = false;
			}			
		}
		public function secStartingState(){
			var atkRange;
			
			var target:StatUnit;
			var tp:Point;
			
			var dist:Number;
			
			atkRange = unitData.abilities[0].range;
			
			
			target = getCloserPlayer();
			tp = new Point(target.x, target.y);
			
			dist = getDistance(target);
			if (dist < atkRange) {
				// attack
				castAbility(0, tp);
				
				wait = 30;
				path = new Array();
			}
			else {
				chaseTarget(target, 1000);
			}
			
			angerDelay--;
			if(angerDelay <= 0){
				angerDelay = maxAngerDelay;
				anger = Math.max(Math.min(999, anger + angerInc), 100);	
				
			}			
		}
		public function secAngryState(){
			//turn invulnerable
			//when done
			wait = 96;
			anger = 100;
		}
	}
}