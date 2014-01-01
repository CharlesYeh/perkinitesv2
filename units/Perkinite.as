package units {
	import flash.events.Event;
	import flash.geom.Point;
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
		
		override public function takeDamage(dmg:int, attackName:String):void {
			Game.playerProgress.takeDamage(dmg);
			
			if(dmg > 0 && visible){
				glowHit.alpha = 1.0;
				this.swf.filters = [glowHit];				
			}
		}
		
		override protected function getSpeed():Number {
			var buff = Game.playerProgress.buffs["speed"];
			var mod:Number = super.getSpeed();
			if(buff != null) {
				mod = mod * (1 + buff.mod) + buff.base;
			}
			return mod;
		}
		
		override public function moveHandler(e:Event):void {
			var lead:StatUnit = Game.perkinite;
			if(!usingAbility && lead != this && StatUnit.distance(lead, this) <= 40){
				path = new Array();
			}
			super.moveHandler(e);		
		}
		
		override public function castAbility(abID:int, mousePos:Point):Boolean {
			if(Game.playerProgress.buffs.hasOwnProperty("stun")) {
				return false;
			}
			return super.castAbility(abID, mousePos);
			
		}
		
	}
}
