package scripting.conditions {
	import flash.events.Event;
	
	import events.GameEventDispatcher;
	import game.Game;
	import scripting.actions.*;
	
	public class ConditionClearedArea extends Action {
		
		public var map:String = "";
		public var beat:int = -1;
		public var remaining:int = -1;
		override public function parseData(obj:Object):void {
			super.parseData(obj);
			
			map = obj.map;
			if(obj.beat != null){
				beat = obj.beat;
			}
			if(obj.remaining != null){
				remaining = obj.remaining;
			}
		}
		
		override public function act():void {
			super.act();
			Game.eventDispatcher.addEventListener(GameEventDispatcher.BEAT_ENEMY, conditionHandler);
		}
		
		override public function update():Boolean {
			return super.update() || Game.playerProgress.hasClearedArea(map);
		}
		
		public function conditionHandler(e:Event):void{
			var enemies = Game.world.getEnemies();
			// Check whether you beat a certain number of enemies
			if(beat > 0 && Game.world.maxEnemies - enemies.length >= beat){
				//Game.eventDispatcher.removeEventListener(GameEventDispatcher.BEAT_ENEMY, conditionHandler);
				complete();				
			}
			// Check whether you have a certain number of enemies remaining
			else if(remaining > 0 && enemies.length <= remaining){
				//Game.eventDispatcher.removeEventListener(GameEventDispatcher.BEAT_ENEMY, conditionHandler);
				complete();
			}
			else if(enemies.length == 0 || update()){
				Game.eventDispatcher.removeEventListener(GameEventDispatcher.BEAT_ENEMY, conditionHandler);
				Game.playerProgress.addClearedArea(map);
				complete();
				update();
			}
		}
		
	}
}