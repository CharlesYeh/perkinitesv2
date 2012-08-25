package units {
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

		/*** Animation ***/
		public var currentAnimLabel:String;

		/*** Cutscenes ***/
		public var commands:Array;// queue of Command's for cutscene commands
		public static var pauseAction:Boolean;// pause the movement of the GameUnit

		/*** Movement ***/
		public var speed:Number;
		public var path:Array = new Array();
		public var moveDir:int;	// 0=right, 1=up, 2=left, 3=down

		/*** Dialogue ***/
		public var dialogueName:String;
		public var dialogueMsg:Array;
		public var dialogueTrigger:String;// how to trigger dialogue

		public function GameUnit() {
			commands = new Array  ;
			pauseAction = false;

			speed = 150;
			path = new Array();
			moveDir = 0;	// right

			dialogueName = "";
			dialogueMsg= new Array();
			dialogueTrigger = "None";

			addEventListener(Event.ENTER_FRAME, moveHandler);
		}
		public function inRadius(r:int, mp:Point) {
			var dx = mp.x - x;
			var dy = mp.y - y;
			var d = dx * dx + dy * dy;
			
			return r * r > d;
		}
		//----------------------------------MOVEMENT----------------------------------
		
		/**
		 * move relative to current position
		 * don't smooth since distance is small
		 */
		public function moveDelta(dx:Number, dy:Number):void {
			moveTo(x + dx,	y + dy, false) || 
			moveTo(x,		y + dy, false) || 
			moveTo(x + dx,	y, false);
		}
		
		/**
		 * Start movement to new destination
		 * 
		 * @param object
		 * @param targetX
		 * @param targetY
		 *
		 * @return whether a path was found
		 */
		public function moveTo(targetX:Number, targetY:Number, smoothing:Boolean = true):Boolean {
			
			if (TileMap.hitNonpass(targetX, targetY)) {
				// pressed on non-moveable place
				return false;
			} else {
				var startTile:Point= new Point(Math.floor(x / TileMap.TILE_SIZE), Math.floor(y / TileMap.TILE_SIZE));
				var destTile:Point = new Point(Math.floor(targetX / TileMap.TILE_SIZE), Math.floor(targetY / TileMap.TILE_SIZE));

				var npath:Array;
				if (smoothing) {
					npath = smoothPath(TileMap.findPath(TileMap.map, startTile, destTile, false, true));
				}
				else {
					npath = TileMap.findPath(TileMap.map, startTile, destTile, false, true);
				}
				
				if (npath.length == 0)
					return false;
				
				path = npath;
				
				// convert tiles to pixels
				for (var a = 0; a < path.length; a++) {
					path[a].x = (path[a].x + .5) * TileMap.TILE_SIZE;
					path[a].y = (path[a].y + .5) * TileMap.TILE_SIZE;
				}
				
				path.shift();
				
				// replace last point with actual destination
				path.pop();
				path.push(new Point(targetX, targetY));
				
				return true;
			}
		}
		public function teleportTo(targetX:int, targetY:int) {
			if (TileMap.hitNonpass(targetX, targetY)) {
				// invalid destination
			}
			else {
				x = targetX;
				y = targetY;
			}
		}

		public function clearPath():void {
			path = new Array();
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
				var radian = turnTo(path[0]);
				
				var nx = x + speed * Math.cos(radian) / 24;
				var ny = y + speed * Math.sin(radian) / 24;
				
				teleportTo(nx, ny);
			}
		}
		// set moveDir and return direction in radians
		public function turnTo(point) {
			var radian = Math.atan2(point.y - y, point.x - x);
			moveDir = (-Math.floor(radian / (Math.PI / 2) + .5) + 4) % 4;
			
			return radian;
		}
		public function turnLeft() {
			moveDir = ++moveDir % 4;
		}
		public function turnRight() {
			moveDir = (moveDir == 0) ? 3 : (moveDir - 1);
		}
		protected function setSpeed(s) {
			speed = s;
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