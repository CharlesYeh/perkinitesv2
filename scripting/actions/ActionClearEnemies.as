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
			
			var createdUnits = Game.playerProgress.getCreatedUnits();
			for(var j = 0; j < createdUnits.length; j++){
				if(createdUnits[j].subtype == "enemy"){
					createdUnits.splice(j, 1);
					j--;
				}
			}
			Game.playerProgress.setCreatedUnits(createdUnits);
			
			complete();
		}
	}
}