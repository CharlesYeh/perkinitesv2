package game {
	import util.*;
	import tileMapper.*;
	import game.GameUnit;

	import flash.geom.Point;
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.*;
	import flash.ui.*;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flashx.textLayout.operations.MoveChildrenOperation;

	public class MapManager {
		public static var mapClip = new MovieClip();
		public static var mapCode:String;
		public static var mapName:String;

		public static var mapWidth:Number;
		public static var mapHeight:Number;
		
		public static var startX:Number;
		public static var startY:Number;

		public static var trackUnit1:GameUnit, trackUnit2:GameUnit;

		// for cutscene scrolling
		public static var scrollDir = 0;
		public static var speed		= 0;
		public static var distance	= 0;	// distance so far
		public static var totalDistance = 0;// distance to travel
		public static var scrolling:Boolean = false;

		public static var tileClings = new Array(false, false, false, true, true, false);

		public static function loadMap(mapNumber:int, unit1:GameUnit, unit2:GameUnit) {
			InteractiveTile.resetTiles();
			
			loadMapData(mapNumber);
			setMapObjects(mapNumber);
			//setEnemies();

			ScreenRect.createScreenRect(new Array(mapClip), 640, 480);
			mapClip.addEventListener(Event.ENTER_FRAME, scrollHandler);
			
			trackUnit1 = unit1;
			trackUnit2 = unit2;
			
			return mapClip;
		}
		public static function addToMapClip(mc:MovieClip) {
			mapClip.addChild(mc);
		}
		public static function depthSortHandler(e) {
			var depthArray:Array = new Array();
			for (var i:int = 0; i < mapClip.numChildren; i++) {
				var child = mapClip.getChildAt(i);
				if (!(mapClip.getChildAt(i) is Tile0)) {//&& ScreenRect.inBounds(mapClip.getChildAt(i))) {
					depthArray.push(mapClip.getChildAt(i));
				}
			}
			
			depthArray.sortOn("y", Array.NUMERIC);
			
			var t = mapClip.numChildren;
			i = depthArray.length;
			while (i--) {
				t--;
				if (mapClip.getChildIndex(depthArray[i]) != t) {
					mapClip.setChildIndex(depthArray[i], t);
				}
			}
		}
		public static function loadMapData(mapNumber:int) {
			stopScrolling();
			TileMap.removeTiles(mapClip);
			
			var map:Map = MapDatabase.getMap(mapNumber);
			mapCode = map.mapCode;
			mapName = map.mapName;
			
			TileMap.removeTiles(mapClip);
			
			var tileset:Tileset = MapDatabase.getTileset(map.tilesetID);
			//-------------------------------######################
			var tileTypes = tileset.tileTypes;
			
			TileMap.createTileMap(mapCode, 32, tileTypes, tileClings, "Tile");
			TileMap.addTiles(mapClip);

			var firstSep = mapCode.indexOf(":");
			var secSep = mapCode.indexOf(":", firstSep + 1);
			mapWidth = parseInt(mapCode.substring(firstSep + 1, secSep));
			mapHeight = parseInt(mapCode.substring(0, firstSep));
			
			var ind1 = mapCode.indexOf("(") + 1;
			var ind2 = mapCode.indexOf(",", ind1);
			startX	= parseInt(mapCode.substring(ind1, ind2));
			
			ind1	= ind2 + 1;
			ind2	= mapCode.indexOf(")");
			startY	= parseInt(mapCode.substring(ind1, ind2));
			
			startX = (startX + .5) * TileMap.TILE_SIZE;
			startY = (startY + .5) * TileMap.TILE_SIZE;
		}
		public static function setHeroPosition(hero:GameUnit, partner:GameUnit) {
			ScreenRect.setX(startX - ScreenRect.STAGE_WIDTH / 2);
			ScreenRect.setY(startY - ScreenRect.STAGE_HEIGHT / 2);
			
			hero.x = startX - TileMap.TILE_SIZE / 2;
			hero.y = startY;
			partner.x = startX + TileMap.TILE_SIZE / 2;
			partner.y = startY;
		}

		public static function setMapObjects(mapNumber:int) {
			/*var mapObjects = MapDatabase.getMapObjects(mapNumber);
			var auto = -1;
			for (var i = 0; i < mapObjects.length; i++) {
				if(mapObjects[i].parent == mapClip){
					mapClip.removeChild(mapObjects[i]);
				}
				if (MapObjectConditionChecker.checkCondition(mapObjects[i], mapObjects[i].conditions)) {
					mapClip.addChild(mapObjects[i]);
					mapObjects[i].determineActivation();
					if (mapObjects[i].aTrigger == "Auto" && auto == -1) {
						mapObjects[i].addEventListener(Event.ENTER_FRAME, mapObjects[i].gameHandler);
						auto = i;
						GameUnit.objectPause = true;
					}
				}
			}*/
		}
		public static function setEnemies() {
			/*var e = new Enemy(5);
			mapClip.addChild(e);
			e.x = 4 * 32 + 16;
			e.y = 9 * 32 + 16;*/
		}


		public static function startScrolling(scrollDir, numTiles, speed, startX, startY) {
			scrollDir = scrollDir;
			distance = 0;
			totalDistance = numTiles * 32;
			speed = speed;
			
			ScreenRect.setX(startX);
			ScreenRect.setY(startY);
			
			scrolling = true;
		}

		public static function stopScrolling() {
			scrolling = false;
		}
		public static function scrollHandler(e) {
			// follow player
			if (!scrolling) {
				//ScreenRect.setX(trackUnit.x - 640 / 2);
				//ScreenRect.setY(Math.max(trackUnit.y - 480 / 2,0));
				var sx = (trackUnit1.x + trackUnit2.x - 640) / 2;
				var sy = (trackUnit1.y + trackUnit2.y - 480) / 2;
				ScreenRect.easeScreen(new Point(sx, sy));
				
				checkScreenRect();
			}
			else {
				// move to set point
				if (distance < totalDistance) {
					var xdist = 0;
					var ydist = 0;
					switch (scrollDir) {
						case 2 :
							ydist = speed;
							break;
						case 4 :
							xdist = -1 * speed;
							break;
						case 6 :
							xdist = speed;
							break;
						case 8 :
							ydist = -1 * speed;
							break;
					}
					
					ScreenRect.setX(ScreenRect.getX() + xdist - ScreenRect.STAGE_WIDTH / 2);
					ScreenRect.setY(Math.max(ScreenRect.getY() + xdist - ScreenRect.STAGE_HEIGHT / 2, 0));
					
					checkScreenRect();
					
					distance += Math.sqrt(Math.pow(xdist, 2) + Math.pow(ydist, 2));
				}
			}
		}
		static function checkScreenRect() {
			if (ScreenRect.getX() < 0) {
				ScreenRect.setX(0);
			}
			if (ScreenRect.getY() < 0) {
				ScreenRect.setY(0);
			}
			if (ScreenRect.getX() + 640 > mapWidth * 32) {
				ScreenRect.setX(mapWidth * 32 - 640);
			}
			if (ScreenRect.getY() + 480 > mapHeight * 32) {
				ScreenRect.setY(mapHeight * 32 - 480);
			}
		}
	}
}