package scripting.actions {
	
	import game.Game;
	
	public class ActionNext extends Action {
		public var map:String;
		public var x:int;
		public var y:int;
		
		override public function parseData(obj:Object):void {
			super.parseData(obj);
			
			map = obj.map;
			x = obj.x;
			y = obj.y;
			
		}
		override public function act():void {
			super.act();
			
			Game.playerProgress.nextLevel(map, x, y);
			
			complete();
		}
	}
}