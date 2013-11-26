package scripting.conditions {
	import game.Game;
	import game.GameConstants;
	import scripting.actions.*;
	
	public class ConditionNPC extends Action {
		
		public var tx;
		public var ty;
		public var radius;
		
		override public function parseData(obj:Object):void {
			super.parseData(obj);
			tx = (obj.x * GameConstants.TILE_SIZE) + (GameConstants.TILE_SIZE >> 1);
			ty = (obj.y * GameConstants.TILE_SIZE) + (GameConstants.TILE_SIZE >> 1);
			radius = obj.radius;
		}

		override public function act():void {
			super.act();
		}
		
		override public function update():Boolean {
			var dx = tx - Game.team[0].x;
			var dy = ty - Game.team[0].y;
			var dist = Math.sqrt(dx * dx + dy * dy);
			
			if(dist <= radius){
				complete();
			}
			return super.update();
		}
	}
}