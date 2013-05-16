package units {
	import flash.events.Event;
	import flash.net.URLRequest;
	
	import db.dbData.CharacterData;
	
	import game.Game;
	import game.Controls;
	import game.Player;
	
	public class Perkinite extends StatUnit {
		public function Perkinite(charData:CharacterData) {
			super(charData);
			
			progressData.health = unitData.health;
			setSpeed(unitData.speed);
			
			removeChild(this.healthbar);
				
			// load swf
			loadSwf();
		}
		
		override public function takeDamage(dmg:int):void {
			Game.playerProgress.takeDamage(dmg);
			
			if(dmg > 0 && visible){
				glowHit.alpha = 1.0;
				this.swf.filters = [glowHit];				
			}
		}
		
		override public function moveHandler(e:Event):void {
			var lead:StatUnit = Game.team[0];
			if(!usingAbility && lead != this && StatUnit.distance(lead, this) <= 40){
				path = new Array();
			}
			super.moveHandler(e);		
		}
		
	}
}
