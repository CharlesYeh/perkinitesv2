package scripting.conditions {
	import game.Game;
	import scripting.actions.*;
	
	public class ConditionBeatEnemies extends Action {
		
		override public function parseData(obj:Object):void {
			super.parseData(obj);
		}
		
		override public function act():void {
			super.act();
		}
		
		override public function update():void {
			return m_completed;
		}
		
		
	}
}