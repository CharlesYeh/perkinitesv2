package units {
	import db.dbData.TeleportData;
	
	import game.GameConstants;
	
	public class Teleport extends GameUnit {
		
		private var m_enabled:Boolean = true;
		public var teleData:TeleportData;
		
		public function Teleport(tdat:TeleportData) {
			teleData = tdat;
			
			x = (tdat.entryX * GameConstants.TILE_SIZE) + (GameConstants.TILE_SIZE >> 1);
			y = (tdat.entryY * GameConstants.TILE_SIZE) + (GameConstants.TILE_SIZE >> 1);
		}
		
		override public function set enabled(val:Boolean):void {
			if (m_enabled != val) {
				gotoAndPlay(val ? "enabled" : "disabled");
			}
			
			m_enabled = val;
		}
		
		override public function get enabled():Boolean {
			return m_enabled;
		}
	}
	
}
