package scripting.conditions {
	import flash.events.Event;
	
	import events.GameEventDispatcher;
	import game.Game;
	import scripting.actions.*;
	
	public class ConditionClearedArea extends Action {
		
		public var map:String = "";
		override public function parseData(obj:Object):void {
			super.parseData(obj);
			
			map = obj.map;
		}
		
		override public function act():void {
			super.act();
			Game.eventDispatcher.addEventListener(GameEventDispatcher.BEAT_ENEMY, conditionHandler);
		}
		
		public function conditionHandler(e:Event):void{
			var enemies = Game.world.getEnemies();
			if(enemies.length == 0){
				Game.eventDispatcher.removeEventListener(GameEventDispatcher.BEAT_ENEMY, conditionHandler);
				Game.playerProgress.clearedAreas.push(map);
				complete();
				update();
			}
		}
		
	}
}