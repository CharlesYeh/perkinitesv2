package scripting.actions {
	
	import game.GameConstants;
	import game.Game;
	
	import flash.geom.Point;
	
	public class ActionDelete extends Action{
		
		/** type of thing to delete */
		
		public var sprite:String;
		
		override public function parseData(obj:Object):void {
			super.parseData(obj);
			
			sprite = obj.sprite;
		}
		
		override public function act():void {
			super.act();
			
/*			if(subtype == "custom"){
				var customs:Array = Game.world.getCustoms();
				for(var i:String in customs){
					if(Math.floor(customs[i].x/GameConstants.TILE_SIZE) == position.x &&
					   Math.floor(customs[i].y/GameConstants.TILE_SIZE) == position.y){
		   					Game.world.clearCustom(customs[i]);
							break;
					   }
				}						
			}
			else if(subtype == "enemy"){
				var enemies:Array = Game.world.getEnemies();
				for(i in enemies){
					if(Math.floor(enemies[i].x/GameConstants.TILE_SIZE) == position.x &&
					   Math.floor(enemies[i].y/GameConstants.TILE_SIZE) == position.y){
		   					Game.world.clearEnemy(enemies[i]);
							break;
					   }
				}				
			}
			else if(subtype == "teleport"){
				var teleports:Array = Game.world.getTeleports();
				for(i in teleports){
					if(teleports[i].teleData.entryX == position.x && 
					   teleports[i].teleData.entryY == position.y){
						   Game.world.clearTeleport(teleports[i]);
						   break;
					   }
				}						
			}
			else*/ 
			if(subtype == "npc"){
				var npcs:Array = Game.world.getNPCs();
				for(var i:String in npcs){
					if(npcs[i].mapCharacterData.id == sprite){
						   Game.world.clearNPC(npcs[i]);
						   break;
					   }
				}						
			}			

			
			complete();
		}
	}
}