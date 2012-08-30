﻿package scripting.actions {
	import game.Game;
	
	public class ActionHUD extends Action{
		/** whether to enable to disable HUD */
		public var enable:Boolean;
		
		
		override public function parseData(obj:Object):void {
			enable = obj.enable;
		}
		
		override public function act():void {
			super.act();
			
			Game.overlay.hud.visible = enable;
			complete();
		}
	}
}