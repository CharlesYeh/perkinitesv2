package scripting.actions {
	import game.Game;
	import game.GameConstants;
	
	import units.GameUnit;
	
	
	public class ActionMove extends Action{
		
		public var sprite:String;
		public var xpos:int;
		public var ypos:int;
		
		public var unit:GameUnit;
		
		override public function parseData(obj:Object):void {
			super.parseData(obj);
			
			sprite = obj.sprite;
			xpos = (obj.xpos * GameConstants.TILE_SIZE) + (GameConstants.TILE_SIZE >> 1);
			ypos = (obj.ypos * GameConstants.TILE_SIZE) + (GameConstants.TILE_SIZE >> 1);	
		}
		
		override public function update():Boolean {	
			if (unit != null &&
				Math.abs(unit.x - xpos) <= GameConstants.TILE_SIZE/2 &&
				Math.abs(unit.y - ypos) <= GameConstants.TILE_SIZE/2) {
				complete();
			}
			return super.update();
		}
		
		override public function act():void {
			super.act();
			
			if(subtype == "npc"){
				var npcs:Array = Game.world.getNPCs();
				for(var i:String in npcs){
					if(npcs[i].mapCharacterData.id == sprite){
						npcs[i].moveTo(xpos, ypos);
						unit = npcs[i];
						break;
					}
				}						
			} else if (subtype == "player") {
				Game.team[0].moveTo(xpos, ypos);
				unit = Game.team[0];
				
			}

		}
	}
}