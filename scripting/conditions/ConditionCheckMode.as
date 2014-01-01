package scripting.conditions {
	import flash.events.Event;
	
	import events.BeatEnemyEvent;
	import events.GameEventDispatcher;
	import game.Game;
	import scripting.actions.*;
	
	public class ConditionCheckMode extends Action {

		public var gameMode:int;
		
		override public function parseData(obj:Object):void {
			super.parseData(obj);
			
			gameMode = obj.gameMode;
		}
		
		override public function act():void {
			super.act();
		}
		
		override public function update():Boolean {
			reset();
			
			if(Game.playerProgress.gameMode == gameMode) {
				complete();
			}
			
			return super.update();
		}
	}
}