package game {
	import game.Game;
	import scripting.Sequence;
	
	import util.KeyDown;
	
	import tileMapper.*;
	
	import events.GameEventDispatcher;
	
	import flash.events.MouseEvent;
	import flash.events.KeyboardEvent;
	import flash.events.Event;
	
	import flash.ui.Keyboard;
	
	import flash.external.ExternalInterface;
	
	import flash.geom.Point;
	
	public class Controls {
		public static var MOVEMENT_DELTA = 10;
		
		public static var acceptRightClicks:Boolean = false;
		public static var secondaryClick:Boolean = false;
		
		public static var aiming1:Boolean = false;
		public static var aiming2:Boolean = false;
		
		private static var m_enabled:Boolean = true;
		
		public static function set enabled(val:Boolean):void {
			m_enabled = val;
		}
		
		public static function setupRightClick():void {
			if (ExternalInterface.available) {
				try {
					ExternalInterface.addCallback("rightClickDown", rightClickDown);
					ExternalInterface.addCallback("rightClickUp", rightClickUp);
				} catch (e:Error) {
					trace("Error: " + e.message);
				}
			}
			else {
				trace("Error adding right click callbacks");
			}
			
			secondaryClick = ExternalInterface.available;
		}
		
		/**
		 * use either right click or space bar (if right click not possible) for ability #2
		 */
		public static function rightClickDown(x:int, y:int):void {
			if (acceptRightClicks) {
				aiming1 = false;
				aiming2 = true;
				showGuides(1, KeyDown.mousePoint);
			}
		}
		
		public static function rightClickUp(x:int, y:int):void {
			if (acceptRightClicks && aiming2) {
				aiming2 = false;
				castAbilities(1, KeyDown.mousePoint);
			}
		}
		
		public static function mouseDownHandler(e:Event):void {
			aiming1 = true;
			aiming2 = false;
			showGuides(0, KeyDown.mousePoint);
		}
		
		public static function mouseUpHandler(e:Event):void {
			if(aiming1){
				aiming1 = false;
				castAbilities(0, KeyDown.mousePoint);
			}
		}
		
		public static function keyDownHandler(e:Event):void {
			var ke:KeyboardEvent = e as KeyboardEvent;
			
			if (ke.keyCode == Keyboard.SPACE/* && !acceptRightClicks*/) {
				aiming1 = false;
				aiming2 = true;
				showGuides(1, KeyDown.mousePoint);
			}
			
			if (ke.keyCode == Keyboard.B) {
				var seqs:Array = Game.world.mapData.sequences;
				for (var i:String in seqs) {
					var seq:Sequence = seqs[i];
					seq.complete();
				}
				
				m_enabled = true;
				Game.overlay.fader.visible = false;
			}
		}
		
		public static function keyUpHandler(e:Event):void {
			if ((e as KeyboardEvent).keyCode == Keyboard.SPACE/* && !acceptRightClicks*/ && aiming2) {
				aiming2 = false;
				castAbilities(1, KeyDown.mousePoint);
			}
		}
		
		public static function startGameInputs():void {
			if (secondaryClick) {
				acceptRightClicks = true;
			}
			
			KeyDown.subscribe(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			KeyDown.subscribe(MouseEvent.MOUSE_UP, mouseUpHandler);
			KeyDown.subscribe(KeyboardEvent.KEY_DOWN, keyDownHandler);
			KeyDown.subscribe(KeyboardEvent.KEY_UP, keyUpHandler);
		}
		
		public static function endGameInputs():void {
			if (secondaryClick) {
				acceptRightClicks = false;
			}
			
			KeyDown.unsubscribe(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			KeyDown.unsubscribe(MouseEvent.MOUSE_UP, mouseUpHandler);
			KeyDown.unsubscribe(KeyboardEvent.KEY_DOWN, keyDownHandler);
			KeyDown.unsubscribe(KeyboardEvent.KEY_UP, keyUpHandler);
		}
		
		/**
		 * show aim guides for whole team
		 */
		public static function showGuides(abilityId:int, pt:Point):void {
			if (!m_enabled) {
				return;
			}
			
			var stagePoint = new Point(pt.x + ScreenRect.getX(), pt.y + ScreenRect.getY());
			for (var i:String in Game.team) {
				// TODO: attack with:
				Game.team[i].showGuide(abilityId, stagePoint);
			}
		}
		
		/**
		 * cast abilities for team
		 */
		public static function castAbilities(abilityId:int, pt:Point):void {
			if (!m_enabled) {
				return;
			}
			
			var stagePoint = new Point(pt.x + ScreenRect.getX(), pt.y + ScreenRect.getY());
			for (var i:String in Game.team) {
				// TODO: attack with:
				Game.team[i].hideGuide();
				Game.team[i].castAbility(abilityId, stagePoint);
			}
		}		 
		
		/*
		 * Move the leader, and have all other characters follow
		 */
		public static function handleGameInputs() {
			if (!m_enabled) {
				return;
			}
			
			var horz:int = 0;
			var vert:int = 0;
			
			if (KeyDown.keyIsDown(Keyboard.W) || KeyDown.keyIsDown(Keyboard.UP)) {
				vert--;
			}
			if (KeyDown.keyIsDown(Keyboard.A) || KeyDown.keyIsDown(Keyboard.LEFT)) {
				horz--;
			}
			if (KeyDown.keyIsDown(Keyboard.S) || KeyDown.keyIsDown(Keyboard.DOWN)) {
				vert++;
			}
			if (KeyDown.keyIsDown(Keyboard.D) || KeyDown.keyIsDown(Keyboard.RIGHT)) {
				horz++;
			}
			if (aiming2) {
				showGuides(1, KeyDown.mousePoint);
			}			
			if(aiming1){
				showGuides(0, KeyDown.mousePoint);
			}
			
			Game.moveTeam(horz * MOVEMENT_DELTA, vert * MOVEMENT_DELTA);
		}
		
	}
}
