package scripting.actions {
	
	import game.Game;
	
	public class ActionDelete extends Action{
		
		/** type of thing to delete */
		
		public var position:Point;
		
		override public function parseData(obj:Object):void {
			super.parseData(obj);
			
			position = obj.position;
		}
		
		override public function act():void {
			super.act();
			
			if(subtype == "custom"){
				var customs = Game.world.getCustoms();
				for(var i:String in customs){
					if(Math.floor(customs[i].x/GameConstants.TILE_SIZE) == position.x &&
					   Math.floor(customs[i].y/GameConstants.TILE_SIZE) == position.y){
		   					Game.world.clearCustom(customs[i]);
							break;
					   }
				}						
			}
			else if(subtype == "enemy"){
				var enemies = Game.world.getEnemies();
				for(var i:String in enemies){
					if(Math.floor(enemies[i].x/GameConstants.TILE_SIZE) == position.x &&
					   Math.floor(enemies[i].y/GameConstants.TILE_SIZE) == position.y){
		   					Game.world.clearEnemy(enemies[i]);
							break;
					   }
				}				
			}
			else if(subtype == "teleport"){
				var teleports = Game.world.getTeleports();
				for(var i:String in teleports){
					if(teleports[i].teleData.entryX = position.x && 
					   teleports[i].teleData.entryY = position.y){
						   Game.world.clearTeleport(teleports[i]);
						   break;
					   }
				}						
			}

			
			complete();
		}
	}
}