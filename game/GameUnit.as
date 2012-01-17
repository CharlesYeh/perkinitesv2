package game{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import tileMapper.TileMap;

	/**
	  * The basic unit in the game. Can be a Unit, Enemy, NPC, Event, etc.
	  */
	public class GameUnit extends MovieClip {

		public var objectWidth:Number;
		public var objectHeight:Number;

		public var range:Number;

		/*** Animation ***/
		public var currentAnimLabel:String;

		/*** Cutscenes ***/
		public var commands:Array;// queue of Command's for cutscene commands
		public static var pauseAction:Boolean;// pause the movement of the GameUnit

		/*** Movement ***/
		public var speed:Number;
		public var path:Array = new Array();
		public var moveRadians:Number;

		/**
		 * dir - direction of GameUnit
		 * moveDir - direction of GameUnit when moving
		 */
		public var moveDir:int;

		/*** Dialogue ***/
		public var dialogueName:String;
		public var dialogueMsg:Array;
		public var dialogueTrigger:String;// how to trigger dialogue

		public function GameUnit() {
			commands = new Array  ;
			pauseAction = false;

			speed = 5;
			path = new Array();
			moveRadians = 0;

			dialogueName = "";
			dialogueMsg= new Array();
			dialogueTrigger = "None";

			addEventListener(Event.ENTER_FRAME, moveHandler);
		}

		/**
		 * Gets the animation label for the direction and action.
		 */
		public function getAnimLabel(moveDir:int, KO:Boolean):String {
			var label = "";
			switch (moveDir) {
				case 0:
					label = "_walkDown";
					break;
				case 1:
					label = "_walkLeft";
					break;
				case 2:
					label = "_walkRight";
					break;
				case 3:
					label = "_walkUp";
					break;
			}
			return label;
		}
		//----------------------------------MOVEMENT----------------------------------
		
		/**
		 * 
		 * Moves the passed GameUnit to its destination.
		 * 
		 * @paramobject
		 * @paramtargetX
		 * @paramtargetY
		 */
		public function moveTo(targetX:Number, targetY:Number):void {
			var p = new Array();
			//startAnimation(dir)
			//really big bug to fix - hitting nonpassable tiles causes crappy movement.
			//hackhackhack
			if (TileMap.hitNonpass(targetX,targetY)) {
				//teleportObject(object, targetX, targetY);
			} else {
				var startTile:Point= new Point(Math.floor(x / 32), Math.floor(y / 32));
				var destTile:Point= new Point(Math.floor(targetX / 32), Math.floor(targetY / 32));

				p = smoothPath(TileMap.findPath(TileMap.map,startTile,destTile,false,true));

				path = p;
				//object.addEventListener(Event.ENTER_FRAME, moveHandler);
			}
		}

		/**
		 * 
		 * Ignores some of the intermediate tile destinations for more realistic movement.
		 * @parampath - the path to modify
		 * @return the smoothed path
		 */
		public function smoothPath(path:Array):Array {
			if (path.length > 0) {
				
				// if start = end, return path with one point
				if (path[0] == path[path.length - 1]) {
					return new Array(path[0]);
				}
				// if straight line from start to end works, just use end points
				if (TileMap.walkable(path[0], path[path.length - 1])) {
					return new Array(path[0], path[path.length - 1]);
				}
				
				var currentIndex = 0;
				var pushIndex = 0;
				
				var newPath = new Array(path[0]);
				for (var nextIndex = 1; nextIndex < path.length; nextIndex++) {
					if (TileMap.walkable(path[nextIndex], path[path.length - 1])) {
						// if line to end works, finish
						newPath.push(path[nextIndex]);
						newPath.push(path[path.length-1]);
						return newPath;
					} else if (TileMap.walkable(path[currentIndex],path[nextIndex])) {
						pushIndex = nextIndex;
					} else {
						if (currentIndex != pushIndex) {
							newPath.push(path[pushIndex]);
						}
						currentIndex = pushIndex;
					}
				}
				
				newPath.push(path[path.length - 1]);
				return newPath;
			} else {
				return new Array();
			}
		}

		/**
		 * 
		 * the movement handler. 
		 * @parame - Event.ENTER_FRAME
		 */
		public function moveHandler(e:Event):void {
			if (path.length > 0) {
				// ################ GET FIRST COORD
				var targetX = path[0].x;
				var targetY = path[0].y;

				var dist = Math.sqrt(Math.pow(targetX - x, 2) + Math.pow(targetY - y, 2));

				if (dist > 0 && dist > range) {
					var xtile = Math.floor(x / 32);
					var ytile = Math.floor(y / 32);
					if (xtile == path[0].x && ytile == path[0].y) {
						path.splice(0, 1);

						if (path.length > 0) {
							var xdest = path[0].x * 32 + 16;
							var ydest = path[0].y * 32 + 16;
							radian = Math.atan2(ydest - y, xdest - x);
							faceDir(radian);
						}
					}
					if (path.length > 0) {
						moving = true;
						x += speed * Math.cos(radian) / 24;
						y += speed * Math.sin(radian) / 24;

					} else {
						moving = false;
					}
				}
			}
		}
		public function turnLeft() {
			switch (dir) {
				case 2 :
					dir = 6;
					break;
				case 4 :
					dir = 2;
					break;
				case 6 :
					dir = 8;
					break;
				case 8 :
					dir = 4;
					break;
			}

			dir = dir / 2;
		}
		public function turnRight() {
			switch (dir) {
				case 2 :
					dir = 4;
					break;
				case 4 :
					dir = 8;
					break;
				case 6 :
					dir = 2;
					break;
				case 8 :
					dir = 6;
					break;
			}

			dir = dir / 2;
		}
		public function faceRandom() {
			dir = 2 * Math.floor(Math.random() * 4 + 1);
			dir = dir / 2;
		}

		public function eraseObject() {
			if (dialogueTrigger == "Auto") {
				//GameUnit.pauseAction = false;
			}

			parent.removeChild(this);
			removeEventListener(Event.ENTER_FRAME, moveHandler);
		}
	}
}