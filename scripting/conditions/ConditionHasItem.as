package scripting.conditions {
	
	import game.Game;
	
	import scripting.actions.Action;
	
	public class ConditionHasItem extends Action {
		
		public var item:String;
		public var negation:Boolean;
		override public function parseData(obj:Object):void {
			super.parseData(obj);
			item = obj.item;
			negation = (obj.negation) ? obj.negation : false;
		}

		override public function act():void {
			super.act();
		}
		
		override public function update():Boolean {
			if (negation && ! Game.playerProgress.hasUnlockedItem(item)) {
				complete();
			} else if(!negation && Game.playerProgress.hasUnlockedItem(item)) {
				complete();
			}
			
			return super.update();
		}
	}
}
