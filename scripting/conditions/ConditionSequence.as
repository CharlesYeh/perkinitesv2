package scripting.conditions {
	import game.Game;
	import scripting.actions.*;
	
	public class ConditionSequence extends Action {
		
		public var incomplete:Boolean = false;
		public var name:String;
		
		override public function parseData(obj:Object):void {
			super.parseData(obj);
			
			incomplete = obj.incomplete;
			name = obj.name;
		}
		
		override public function act():void {
			super.act();
		}
		
		override public function update():Boolean {
			if (incomplete) {
				return !Game.playerProgress.hasCompletedSequence(name);
			}
			else {
				return Game.playerProgress.hasCompletedSequence(name);
			}
		}
		
		
	}
}