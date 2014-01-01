package scripting.actions {
	
	import game.GameConstants;
	import game.Game;
	
	import db.AbilityDatabase;
	import db.dbData.MapCharacterData;
	
	import events.ObtainItemEvent;
	
	public class ActionEquip extends ActionItem {
		
		override public function parseData(obj:Object):void {
			super.parseData(obj);
		}
		
		override public function act():void {
			super.act();
			
			if(item == "Peace Bear") {
				for(var i = 0; i < Game.team[0].unitData.abilities.length; i++){
					if(Game.team[0].unitData.abilities[i].name == "PEACE<3BEAM") {
						var temp = Game.team[0].unitData.abilities[1];
						Game.team[0].unitData.abilities[1] = Game.team[0].unitData.abilities[i];
						Game.team[0].unitData.abilities[i] = temp;
						break;
					}
				}
				Game.updateHUD();
			}
		}
	}
}