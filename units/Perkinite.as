package units {
	import flash.events.Event;
	import flash.net.URLRequest;
	
	import db.dbData.CharacterData;
	
	public class Perkinite extends StatUnit {
		public function Perkinite(charData:CharacterData) {
			super(charData);
			
			progressData.health = unitData.health;
			setSpeed(unitData.speed);
			
			// load swf
			loadSwf();
		}
		override public function takeDamage(dmg:int):void {
			if(progressData.health > 0){
				progressData.health = Math.max(0, progressData.health - dmg);
				drawHealthbar();
				if(progressData.health <= 0){
					progressData.deathTimer = 100;
				}				
			}
		}
		
		override public function moveHandler(e:Event):void{
			// adjust cooldowns
			if (progressData.health <= 0) {
					progressData.deathTimer--;
				if(progressData.deathTimer <= 0){
					progressData.health += 15;
				}
				else{
					return;					
				}
			}
			super.moveHandler(e);
		}
	}
}
