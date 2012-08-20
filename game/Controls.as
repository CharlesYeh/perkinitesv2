package game {
	import util.KeyDown;
	
	import events.GameEventDispatcher;
	
	import flash.ui.Keyboard;
	
	import flash.external.ExternalInterface;
	import events.RightClickEvent;
	
	public class Controls {
		
		public static function setupRightClick():void {
			if (ExternalInterface.available) {
				ExternalInterface.addCallback("rightClicked", rightClicked);
			}
		}
		
		public static function rightClicked(x:int, y:int) {
			GameEventDispatcher.dispatchEvent(new RightClickEvent());
		}
		
		/*
		 * Move the leader, and have all other characters follow
		 */
		public static function handleKeyboard(arr:Array, lead:StatUnit) {
			if (KeyDown.keyIsDown(Keyboard.W) || KeyDown.keyIsDown(Keyboard.UP)) {
				
			}
			if (KeyDown.keyIsDown(Keyboard.A) || KeyDown.keyIsDown(Keyboard.LEFT)) {
				
			}
			if (KeyDown.keyIsDown(Keyboard.S) || KeyDown.keyIsDown(Keyboard.DOWN)) {
				
			}
			if (KeyDown.keyIsDown(Keyboard.D) || KeyDown.keyIsDown(Keyboard.RIGHT)) {
				
			}
			
			for (var i:String in arr) {
				var unit:StatUnit = arr[i];
				
				if (unit == lead) {
					continue;
				}
				else {
					// follow leader
					
				}
			}
		}
		
	}
}
