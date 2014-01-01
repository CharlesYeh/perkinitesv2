package scripting.actions {
	import game.Game;
	
	public class ActionPowerup extends Action{
		/** whether to enable to disable HUD */
		
		public var amount:Number;
		
		
		override public function parseData(obj:Object):void {
			super.parseData(obj);
			
			amount = (obj.amount != null) ? obj.amount : 0;
		}
		
		override public function act():void {
			if(subtype == "health") {
				Game.playerProgress.maxHealth += amount;
				Game.playerProgress.health = Math.min(Game.playerProgress.health + amount, Game.playerProgress.maxHealth);
				Game.perkinite.takeDamage(0, "");
			} else if (subtype == "attack") {
				
			} else if (subtype == "defense") {
				
			} else if (subtype == "speed") {
				
			}
			complete();
		}
	}
}