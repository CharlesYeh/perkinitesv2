package scripting.actions {
	
	import game.GameConstants;
	import game.Game;
	
	import db.dbData.MapCharacterData;
	
	import events.ObtainItemEvent;
	
	public class ActionItem extends Action{
		
		public var item:String;
		public var save:Boolean;
		
		override public function parseData(obj:Object):void {
			super.parseData(obj);
			
			item = obj.item;
			save = (obj.save != null)? obj.save : true;
		}
		
		override public function act():void {
			super.act();
			Game.playerProgress.unlockItem(item);
			Game.eventDispatcher.dispatchEvent(new ObtainItemEvent(item));		
			complete();
		}
	}
}