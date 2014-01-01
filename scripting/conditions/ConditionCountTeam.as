package scripting.conditions {
	import game.Game;

	import scripting.actions.Action;
	
	public class ConditionCountTeam extends Action {
		
		public var size:int;
		
		public var greater:Boolean;
		public var less:Boolean;
		public var equal:Boolean;
		public var active:Boolean;
		
		override public function parseData(obj:Object):void {
			super.parseData(obj);
			
			size = (obj.size != null) ? obj.size : 0;
			greater = (obj.greater != null) ? obj.greater : false;
			less = (obj.less != null) ? obj.less : false;
			equal = (obj.equal != null) ? obj.equal : true;
			active = (obj.active != null) ? obj.active : true;
		}
		
		override public function update():Boolean {
			if(active) {
				
			} else {
				
			}
			
			reset();
			var teamSize = Game.team.length;
			if(equal && teamSize == size) {
					complete();
			}
			if(greater && teamSize > size) {
				complete();
			}
			if(less && teamSize < size) {
				complete();
			}
			return super.update();
		}
	}
}