package scripting.actions {
	
	import game.Game;
	
	public class ActionClearEnemies extends Action{
		/** whether to enable to disable controls */
		public var enable:Boolean;
		
		/** set of controls to enable/disable */
		public var set:String;
		
		override public function parseData(obj:Object):void {
		}
		
		override public function act():void {
			super.act();
			
			var enemies = Game.world.getEnemies();
			for(var i:String in enemies){
				Game.world.clearEnemy(enemies[i]);
				enemies[i].destroy();
			}
			
			complete();
		}
	}
}