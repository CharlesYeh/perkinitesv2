package scripting.actions {
	
	import game.Game;
	import game.progress.PlayerProgress;
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
				Game.playerProgress.gameMode = PlayerProgress.CAMPAIGN_MODE;
				Game.playerProgress.nextLevel(map, x, y);
			} else {
				complete();
				Game.playerProgress.gameMode = PlayerProgress.FREETIME_MODE;
				Game.world.updateSequences();
				
				Game.switchPlayers(0);
				Game.team.splice(1); //remove all teammates except for GK1
				
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