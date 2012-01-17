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
			moveDir = 0;	// right

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
					label = "_walkRight";
					break;
				case 1:
					label = "_walkUp";
					break;
				case 2:
					label = "_walkLeft";
					break;
				case 3:
					label = "_walkDown";
					break;
			}
			return label;
		}
		//----------------------------------MOVEMENT----------------------------------
		
		/**
		 * Start movement to new destination
		 * 
		 * @paramobject
		 * @paramtargetX
		 * @paramtargetY
		 */
		public function moveTo(targetX:Number, targetY:Number):void {
			path = new Array();
			
			// show animation#############################
			
			if (TileMap.hitNonpass(targetX, targetY)) {
				// pressed on non-moveable place
			} else {
				var startTile:Point= new Point(Math.floor(x / 32), Math.floor(y / 32));
				var destTile:Point = new Point(Math.floor(targetX / 32), Math.floor(targetY / 32));

				path = smoothPath(TileMap.findPath(TileMap.map, startTile, destTile, false, true));
				
				// convert tiles to pixels
				for (var a = 0; a < path.length; a++) {
					path[a].x = (path[a].x + .5) * TileMap.TILE_SIZE;
					path[a].y = (path[a].y + .5) * TileMap.TILE_SIZE;
				}
				
				// replace last point with actual destination
				path.pop();
				path.push(targetX, targetY);
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
			if (path.length == 0)
				return;
			
			var targetX = path[0].x;
			var targetY = path[0].y;
			
			var dist = Math.pow(targetX - x, 2) + Math.pow(targetY - y, 2);

			if (dist < 100) {
				// close enough, move onto next point
				path.shift();
			}
			else {
				// keep moving towards path[0]
				var radian = Math.atan2(path[0].y - y, path[0].x - x);
				
				//############# show animation
				x += speed * Math.cos(radian) / 24;
				y += speed * Math.sin(radian) / 24;
			}
		}
		public function turnLeft() {
			moveDir = ++moveDir % 4;
			//####### SHOW ANIMATION
		}
		public function turnRight() {
			moveDir = (moveDir == 0) ? 3 : (moveDir - 1);
			//####### SHOW ANIMATION
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