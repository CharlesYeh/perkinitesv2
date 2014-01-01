package scripting.actions {
	
	import db.dbData.CharacterData;
	import db.dbData.DatabaseData;
	
	import game.Game;
	import game.GameConstants;
	import scripting.actions.Action;
	import units.Perkinite;
	
	public class ActionChangeTeam extends Action {
		
		public var addMember:Boolean;
		public var chosen:Boolean;
		
		override public function parseData(obj:Object):void {
			super.parseData(obj);
			
			if(subtype == "add") {
				addMember = true;
			} else if (subtype == "remove") {
				addMember = false;
			}
			
			if(key == "chosen") {
				chosen = true;
			} else if (key == "npc") {
				chosen = false;
			}
		}
		
		/**
		 * start the action
		 */
		override public function act():void {
			super.act();
			
			var cdat:CharacterData;
			var npcID:String;
			
			if(chosen) {
				npcID = Game.charID;
			} else {
				npcID = Game.world.getActivatedNPC().mapCharacterData.id;
			}
			
			if(addMember) {
				if(Game.team.length > 5) {
					//print out "You have too many members on your active team. 
					//This perkinite will be on your reserve team.
					//To change the lineup, go to your Menu through [ESC].
					complete();
					return;
				}
				
				var check:Boolean = true;
				
				for(var i = 0; i < Game.team.length; i++){
					if(Game.team[i].unitData.id == npcID) {
						check = false;
						break;
					}
				}
				if(check) {
					cdat = Game.dbChar.getCharacterData(npcID);
					var char = new Perkinite(cdat);
					char.x = GameConstants.TILE_SIZE * Game.playerProgress.x + (GameConstants.TILE_SIZE >> 1);
					char.y = GameConstants.TILE_SIZE * Game.playerProgress.y + (GameConstants.TILE_SIZE >> 1);
					
					Game.team.push(char);	
					char.setAbilityTargets(Game.world.getEnemies());
				} else {
					//this perkinite is already on your team! 
				}
			} else {
				for(var i = 0; i < Game.team.length; i++){
					if(Game.team[i].unitData.id == npcID) {
						Game.world.clearCustom(Game.team[i]);
						Game.team.splice(i, 1);
						
						if(i == Game.playerIndex) {
							Game.switchPlayers(0);
						}
						break;
					}
				}				
			}
			
			Game.updateHUD();
			complete();
			
		}
	}
}