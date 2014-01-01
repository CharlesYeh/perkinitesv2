package scripting.actions {
	
	import game.Game;
	import game.GameConstants;
	import game.MapManager;
	
	import db.dbData.TeleportData;
	
	import flash.geom.Point;
	
	public class ActionTeleport extends Action{
				
		public var map:String;
		public var position:Point;
		public var dir:String;
		
		private const directions = new Array("right", "up", "left", "down");
		
		override public function parseData(obj:Object):void {
			super.parseData(obj);
			map = obj.map;
			position = new Point(obj.position.x, obj.position.y);
			dir = obj.direction;
		}
		
		override public function act():void {
			super.act();
			
			if(Game.playerProgress.map == map) {
				Game.playerProgress.x = (position.x * GameConstants.TILE_SIZE) + (GameConstants.TILE_SIZE >> 1);
				Game.playerProgress.y = (position.y * GameConstants.TILE_SIZE) + (GameConstants.TILE_SIZE >> 1);
				Game.perkinite.x = Game.playerProgress.x;
				Game.perkinite.y = Game.playerProgress.y;
			} else {
				complete();
				Game.world.updateSequences();
				var tdata = new TeleportData();
				tdata.exitMap = map;
				tdata.exitX = position.x;
				tdata.exitY = position.y;
				MapManager.changeMap(tdata);
			}
			
			if(dir != null) {
				Game.perkinite.updateDirection(directions.indexOf(dir));
			}
			
			complete();
		}
	}
}