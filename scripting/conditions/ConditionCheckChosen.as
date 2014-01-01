package scripting.conditions {
	import game.Game;

	import scripting.actions.Action;
	
	public class ConditionCheckChosen extends Action {
		
		public var id:String;
		public var npc:Boolean;
		
		override public function parseData(obj:Object):void {
			super.parseData(obj);
			id = obj.id;
			npc = (obj.npc != null) ? obj.npc : false;
		}
		
		override public function update():Boolean {
			if(npc) {
				id = Game.world.getActivatedNPC().mapCharacterData.id;
			}
			if(id == Game.charID) {
				complete();
			}
			return super.update();
		}
	}
}