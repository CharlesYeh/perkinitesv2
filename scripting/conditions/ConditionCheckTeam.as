package scripting.conditions {
	import game.Game;

	import scripting.actions.Action;
	
	public class ConditionCheckTeam extends Action {
		
		public var id:String;
		
		/** check if person chosen on char_select is in */
		public var chosen:Boolean = false;
		public var npc:Boolean = false;
		
		/** check within active team */
		public var active:Boolean = false;
		override public function parseData(obj:Object):void {
			super.parseData(obj);
			id = obj.id;
			chosen = (obj.chosen != null) ? obj.chosen : false;
			npc = (obj.npc != null) ? obj.npc : false;
			active = (obj.active != null) ? obj.active : false;
		}
		
		override public function update():Boolean {
			var max = Game.team.length;
			if(active) {
				max = 5;
			}
			if(chosen) {
				id = Game.charID;
			}
			if(npc) {
				id = Game.world.getActivatedNPC().mapCharacterData.id;
			}
			reset();
			for(var i = 0; i < max; i++){
				if(Game.team[i].unitData.id == id) {
					complete();
					break;	
				}
			}
			return super.update();
		}
	}
}