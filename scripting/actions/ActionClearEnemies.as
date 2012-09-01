package scripting.actions {
	
	import game.Game;
	
	public class ActionClearEnemies extends Action{
		
		override public function act():void {
			super.act();
			
			var enemies = Game.world.getEnemies();
			for(var i:String in enemies){
				Game.world.clearEnemy(enemies[i]);
			}
			
			complete();
		}
	}
}