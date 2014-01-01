package scripting.actions {
	
	import game.Game;
	import game.GameConstants;
	import game.progress.PlayerProgress;
	import game.MapManager;
	import db.dbData.TeleportData;
	import flash.geom.Point;
	
	public class ActionViewport extends Action {
		public var position:Point;
		
		public var player:Boolean;
		
		override public function parseData(obj:Object):void {
			super.parseData(obj);
			
			var xpos = (obj.position != null) ? obj.position.x : -1;
			var ypos = (obj.position != null) ? obj.position.y : -1;
			position = new Point((xpos + 0.5) * GameConstants.TILE_SIZE, 
								 (ypos + 0.5)* GameConstants.TILE_SIZE);

			player = (obj.player != null) ? obj.player : false;
			
		}
		override public function act():void {
			super.act();
			
			Game.customViewport = (!player);
			Game.viewportPoint = position;
			
			complete();
		}
	}
}