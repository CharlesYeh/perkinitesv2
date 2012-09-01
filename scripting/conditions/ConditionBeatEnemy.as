package scripting.conditions {
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
		
		public function conditionHandler(e:Event):void{
			if(e.id == id){
				Game.eventDispatcher.removeEventListener(GameEventDispatcher.BEAT_ENEMY, conditionHandler);
				complete();
				update();
			}
			
		}
		
		override public function update():void {
			return super.update();
		}
		
		
	}
}