package scripting.actions {
	
	import game.Game;
	
	public class ActionClearEnemies extends Action{
		
		override public function act():void {
			super.act();
			
			var enemies = Game.world.getEnemies();
			for(var i = 0; i < enemies.length; i++){
				Game.world.clearEnemy(enemies[i]);
				i--;
			}
			
			for(var j = 0; j < Game.playerProgress.createdUnits.length; j++){
				if(Game.playerProgress.createdUnits[j].subtype == "enemy"){
					Game.playerProgress.createdUnits.splice(j, 1);
					j--;
				}
			}
			
			complete();
		}
	}
}