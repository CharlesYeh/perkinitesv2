package scripting.conditions {
	import game.Game;
	import scripting.actions.*;
	
	public class ConditionSequence extends Action {
		
		public var name:String;
		
		override public function parseData(obj:Object):void {
			super.parseData(obj);
			
			name = obj.name;
		}
		
		override public function act():void {
			super.act();
		}
		
		override public function update():void {
			return Game.playerProgress.hasCompletedSequence(name);
		}
		
		
	}
}