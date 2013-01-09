package scripting.actions {
	import game.Game;
	
	public class ActionHUD extends Action{
		/** whether to enable to disable HUD */
		public var enable:Boolean;
		
		public var enemy:Boolean;
		
		
		override public function parseData(obj:Object):void {
			enable = obj.enable;
			enemy = false;
			if(obj.enemy != null){
				enemy = obj.enemy;
			}
		}
		
		override public function act():void {
			super.act();
			if(enemy){
				Game.overlay.ehud.visible = enable;
			}
			else{
				Game.overlay.hud.visible = enable;				
			}
			complete();
		}
	}
}