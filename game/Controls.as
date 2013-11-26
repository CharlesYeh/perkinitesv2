package game{
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.geom.Point;
	import flash.ui.Keyboard;

	import attacks.Attack;

	import scripting.Sequence;

	import tileMapper.ScreenRect;

	import util.KeyDown;

	import units.AIUnit;
	import units.StatUnit;

	public class Controls {
		private static var MOVEMENT_DELTA:int = 10;

		private static var aiming1:Boolean = false;
		private static var aiming2:Boolean = false;
		
		private static var activateNPC:Boolean = false;

		private static var m_enabled:Boolean = true;

		public static function get enabled():Boolean {
			return m_enabled;
		}

		public static function set enabled(val:Boolean):void {
			m_enabled = val;
		}

		public static function mouseDownHandler(e:Event):void {
			aiming1 = true;
			aiming2 = false;
			showGuides(0, KeyDown.mousePoint);
		}

		public static function mouseUpHandler(e:Event):void {
			if (aiming1) {
				aiming1 = false;
				castAbilities(0, KeyDown.mousePoint);
			}
		}

		/**
		 * use either right click or space bar (if right click not possible) for ability #2
		 */
		public static function rightClickDown(e:Event):void {
			aiming1 = false;
			aiming2 = true;
			showGuides(1, KeyDown.mousePoint);
		}

		public static function rightClickUp(e:Event):void {
			if (aiming2) {
				aiming2 = false;
				castAbilities(1, KeyDown.mousePoint);
			}
		}

		public static function keyDownHandler(e:KeyboardEvent):void {
			if (e.keyCode == Keyboard.SPACE && GameConstants.DEBUG_MODE) {
				aiming1 = false;
				aiming2 = true;
				showGuides(1, KeyDown.mousePoint);
			}

			testCheats(e.keyCode);
		}

		public static function keyUpHandler(e:KeyboardEvent):void {
			if (e.keyCode == Keyboard.SPACE && GameConstants.DEBUG_MODE && aiming2) {
				aiming2 = false;
				castAbilities(1, KeyDown.mousePoint);
			}
		}

		public static function startGameInputs():void {
			KeyDown.subscribe(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			KeyDown.subscribe(MouseEvent.MOUSE_UP, mouseUpHandler);
			KeyDown.subscribe("rightMouseDown", rightClickDown);
			KeyDown.subscribe("rightMouseUp", rightClickUp);
			KeyDown.subscribe(KeyboardEvent.KEY_DOWN, keyDownHandler);
			KeyDown.subscribe(KeyboardEvent.KEY_UP, keyUpHandler);
		}

		public static function endGameInputs():void {
			KeyDown.unsubscribe(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			KeyDown.unsubscribe(MouseEvent.MOUSE_UP, mouseUpHandler);
			KeyDown.unsubscribe("rightMouseDown", rightClickDown);
			KeyDown.unsubscribe("rightMouseUp", rightClickUp);
			KeyDown.unsubscribe(KeyboardEvent.KEY_DOWN, keyDownHandler);
			KeyDown.unsubscribe(KeyboardEvent.KEY_UP, keyUpHandler);
		}

		/**
		 * show aim guides for whole team
		 */
		public static function showGuides(abilityId:int, pt:Point):void {
			if (! m_enabled) {
				return;
			}

			var stagePoint = ScreenRect.fromScreenToGame(pt);
			for (var i:String in Game.team) {
				Game.team[i].showGuide(abilityId, stagePoint);
			}
		}

		/**
		 * cast abilities for team
		 */
		public static function castAbilities(abilityId:int, pt:Point):void {
			if (! m_enabled) {
				return;
			}

			var stagePoint = ScreenRect.fromScreenToGame(pt);
			for (var i:String in Game.team) {
				Game.team[i].hideGuide();
				Game.team[i].castAbility(abilityId, stagePoint);
			}
		}

		/*
		 * Move the leader, and have all other characters follow
		 */
		public static function handleGameInputs():void {
			if (! m_enabled) {
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
			if(!activateNPC && KeyDown.keyIsDown(Keyboard.E)){
				activateNPC = true;
				Game.world.checkNPCs();
			}			
			if(!KeyDown.keyIsDown(Keyboard.E)) {
				activateNPC = false;
			}
			if (aiming2) {
				showGuides(1, KeyDown.mousePoint);
			}
			if (aiming1) {
				showGuides(0, KeyDown.mousePoint);
			}

			Game.moveTeam(horz * MOVEMENT_DELTA, vert * MOVEMENT_DELTA);
		}

		private static function testCheats(key:uint):void {
			if (! GameConstants.DEBUG_MODE) {
				return;
			}

			switch (key) {
				case Keyboard.B :
					// complete sequences on map
					var seqs:Array = Game.world.mapData.sequences;
					for (var i:String in seqs) {
						var seq:Sequence = seqs[i];
						seq.complete();
					}
					m_enabled = true;
					Game.overlay.fader.visible = false;
					Game.overlay.speech.visible = false;
					Game.overlay.narrator.visible = false;
					AIUnit.enabled = true;
					SoundManager.stopSounds();
					break;
				case Keyboard.V :
					// become super damaging
					for (i in Game.team) {
						var su:StatUnit = Game.team[i];
						var abilities:Array = su.unitData.abilities;
						for (var a:String in abilities) {
							var ab:Attack = abilities[a];
							ab.dmgBase = 100000;
						}
					}
					break;
				case Keyboard.C :
					// kill all enemies except one
					var enemies:Array = Game.world.getEnemies();
					for (var j:int = 1; j < enemies.length; j++) {
						su = enemies[j];
						su.takeDamage(100000);
					}
					break;
			}
		}
	}
}