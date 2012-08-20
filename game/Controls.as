package game {
	import game.Game;
	
	import util.KeyDown;
	
	import events.GameEventDispatcher;
	import events.RightClickEvent;
	
	import flash.events.Event;
	
	import flash.ui.Keyboard;
	
	import flash.external.ExternalInterface;
	
	public class Controls {
		
		public static var secondaryClick:Boolean = false;
		
		public static function setupRightClick():void {
			if (ExternalInterface.available) {
				ExternalInterface.addCallback("rightClicked", rightClicked);
			}
			
			secondaryClick = ExternalInterface.available;
		}
		
		public static function rightClicked(x:int, y:int) {
			Game.eventDispatcher.dispatchEvent(new RightClickEvent());
		}
		
		public static function startGameInputs() {
			Game.eventDispatcher.addEventListener(GameEventDispatcher.RIGHT_CLICK, gameRightClick);
		}
		
		public static function gameRightClick(e:Event) {
			for (var i:String in Game.team) {
				// TODO: attack with:
				Game.team[i];
			}
		}
		
		/*
		 * Move the leader, and have all other characters follow
		 */
		public static function handleGameInputs() {
			if (KeyDown.keyIsDown(Keyboard.W) || KeyDown.keyIsDown(Keyboard.UP)) {
				
			}
			if (KeyDown.keyIsDown(Keyboard.A) || KeyDown.keyIsDown(Keyboard.LEFT)) {
				
			}
			if (KeyDown.keyIsDown(Keyboard.S) || KeyDown.keyIsDown(Keyboard.DOWN)) {
				
			}
			if (KeyDown.keyIsDown(Keyboard.D) || KeyDown.keyIsDown(Keyboard.RIGHT)) {
				
			}
			
		}
		
	}
}
