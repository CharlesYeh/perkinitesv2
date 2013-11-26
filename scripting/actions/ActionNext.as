package scripting.actions {
	
	import game.Game;
	import game.MapManager;
	import db.dbData.TeleportData;
	
	public class ActionNext extends Action {
		public var map:String;
		public var x:int;
		public var y:int;
		public var menu:Boolean = false;
		
		override public function parseData(obj:Object):void {
			super.parseData(obj);
			
			map = obj.map;
			x = obj.x;
			y = obj.y;
			if(obj.menu != null) {
				menu = obj.menu;
			}
			
		}
		override public function act():void {
			super.act();
			
			if (menu) {
				Game.playerProgress.nextLevel(map, x, y);
			} else {
				complete();
				Game.world.updateSequences();
				var tdata = new TeleportData();
				tdata.exitMap = map;
				tdata.exitX = x;
				tdata.exitY = y;
				MapManager.changeMap(tdata);
			}
			
			complete();
		}
	}
}