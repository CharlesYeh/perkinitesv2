package units {
	import flash.events.Event;
	import flash.net.URLRequest;
	
	import db.dbData.CharacterData;
	
	import game.Game;
	import game.Controls;
	
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
					Controls.enabled = false;
					Game.overlay.gameover.visible = true;
				}				
			}
		}
	}
}
