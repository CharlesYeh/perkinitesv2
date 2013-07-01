package scripting.actions {
	
	import game.GameConstants;
	import game.Game;
	
	import db.dbData.MapCharacterData;
	
	import flash.geom.Point;
	
	public class ActionTeleport extends Action{
				
		public var map:String;
		public var position:Point;
		
		override public function parseData(obj:Object):void {
			super.parseData(obj);
			map = obj.map;
			position = new Point(obj.position.x, obj.position.y);
		}
		
		override public function act():void {
			super.act();
			
			
			complete();
		}
	}
}