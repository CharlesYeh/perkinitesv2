package scripting.conditions {
	import flash.events.Event;
	
	import events.BeatEnemyEvent;
	import events.GameEventDispatcher;
	import game.Game;
	import scripting.actions.*;
	
	public class ConditionBeatEnemy extends Action {
		
		public var id:String;
		
		override public function parseData(obj:Object):void {
			super.parseData(obj);
			
			id = obj.id;
		}
		
		override public function act():void {
			super.act();
			Game.eventDispatcher.addEventListener(GameEventDispatcher.BEAT_ENEMY, conditionHandler);
		}
		
		public function conditionHandler(e:BeatEnemyEvent):void{
			if (e.id == id) {
				Game.eventDispatcher.removeEventListener(GameEventDispatcher.BEAT_ENEMY, conditionHandler);
				for(var j = 0; j < Game.playerProgress.createdUnits.length; j++){
					if(Game.playerProgress.createdUnits[j].id == id){
						Game.playerProgress.createdUnits.splice(j, 1);
						trace(id + " deleted in ConditionBeatEnemy");
						break;
					}
				}
				
				complete();
				update();
			}
			
		}
	}
}