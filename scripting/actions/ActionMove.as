package scripting.actions {
	import game.Game;
	import game.GameConstants;
	
	import units.StatUnit;
	import flash.geom.Point;
	
	
	public class ActionMove extends Action{
		
		public var sprite:String;
		public var xpos:int;
		public var ypos:int;
		public var playerIndex:int = -1;
		public var chosen:Boolean = false;
		public var dir:String;
		
		private const directions = new Array("right", "up", "left", "down");
		
		public var unit:StatUnit;
		
		override public function parseData(obj:Object):void {
			super.parseData(obj);
			
			sprite = obj.sprite;
			xpos = (obj.position != null) ? (obj.position.x * GameConstants.TILE_SIZE) + (GameConstants.TILE_SIZE >> 1) : -1;
			ypos =  (obj.position != null) ? (obj.position.y * GameConstants.TILE_SIZE) + (GameConstants.TILE_SIZE >> 1) : -1;
			playerIndex = (obj.playerIndex != null) ? obj.playerIndex : -1;
			chosen = (obj.chosen != null) ? obj.chosen : false;
			dir = obj.direction;
		}
		
		override public function update():Boolean {	
			if (unit != null &&
				Math.abs(unit.x - xpos) <= GameConstants.TILE_SIZE/2 &&
				Math.abs(unit.y - ypos) <= GameConstants.TILE_SIZE/2 &&
				unit.path.length == 0) {	
				
				if(dir != null) {
					unit.updateDirection(directions.indexOf(dir));
				}
				complete();
			}
			return super.update();
		}
		
		override public function act():void {
			super.act();
			
			var i:String;
			
			if(chosen) {
				sprite = Game.charID;
			} else if(playerIndex >= 0) {
				sprite = Game.team[playerIndex % Game.team.length].unitData.id; 
			}
			
			if(subtype == "npc"){
				var npcs:Array = Game.world.getNPCs();
				for(i in npcs){
					if(npcs[i].mapCharacterData.id == sprite){
						unit = npcs[i];
						break;
					}
				}						
			} else if (subtype == "enemy") {
				var enemies:Array = Game.world.getEnemies();
				for(i in enemies){
					if(enemies[i].unitData.sprite == sprite){
						unit = enemies[i];
						break;
					}
				}							
			} else if (subtype == "player") {
				unit = Game.perkinite;
			}			
			if(xpos != -1 && ypos != -1) {
				unit.moveTo(xpos, ypos);
			} else {
				if(dir != null) {
					unit.updateDirection(directions.indexOf(dir));
				}
				complete();				
			}

		}
	}
}