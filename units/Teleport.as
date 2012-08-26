package units {
	import db.dbData.TeleportData;
	
	import game.GameConstants;
	
	public class Teleport extends GameUnit {
		
		public var teleData:TeleportData;
		
		public function Teleport(tdat:TeleportData) {
			teleData = tdat;
			
			x = (tdat.entryX * GameConstants.TILE_SIZE) + (GameConstants.TILE_SIZE >> 1);
			y = (tdat.entryY * GameConstants.TILE_SIZE) + (GameConstants.TILE_SIZE >> 1);
		}

	}
	
}
