package game {
	import util.*;
	import tileMapper.*;
	import db.MapDatabase;
	import game.GameUnit;

	import flash.geom.Point;
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.*;
	import flash.ui.*;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flashx.textLayout.operations.MoveChildrenOperation;
	import aiunits.AISpawnPoint;

	public class MapManager {
		public static var mapClip = new MovieClip();
		public static var mapCode:String;
		public static var mapName:String;

		public static var mapWidth:Number;
		public static var mapHeight:Number;
		
		static var telePoints:Array;
		static var aiUnits:Array;

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
			//setEnemies();

			ScreenRect.createScreenRect(new Array(mapClip), 640, 480);
			mapClip.addEventListener(Event.ENTER_FRAME, scrollHandler);
			
			trackUnit1 = unit1;
			trackUnit2 = unit2;
			
			return mapClip;
		}
		//-------------AI UNITS-------------
		public static function clearAIUnits() {
			for (var a in aiUnits) {
				var u = aiUnits[a];
				removeFromMapClip(u);
			}
			
			aiUnits = new Array();
		}
		public static function createEnemy(id:int, ox, oy):StatUnit {
			var u = AIUnit.createAIUnit(id);
			u.x = ox;
			u.y = oy;
			u.setDeleteFunction(deleteEnemy);
			
			addToMapClip(u);
			aiUnits.push(u);
			
			return u;
		}
		public static function deleteEnemy(u:StatUnit) {
			aiUnits.splice(aiUnits.indexOf(u), 1);
			removeFromMapClip(u);
		}
		public static function getAIUnits():Array {
			return aiUnits;
		}
		//-----------END AI UNITS-----------
		public static function addToMapClip(mc:MovieClip) {
			mapClip.addChild(mc);
		}
		public static function removeFromMapClip(mc:MovieClip) {
			mapClip.removeChild(mc);
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
		public static function testTeleportPoints(su:StatUnit):MovieClip {
			var sx = Math.floor(su.x / TileMap.TILE_SIZE);
			var sy = Math.floor(su.y / TileMap.TILE_SIZE);
			
			for (var a in telePoints) {
				var t = telePoints[a];
				if (sx == t.tx && sy == t.ty) {
					// change map!
					return t;
				}
			}
			
			return null;
		}
		public static function loadMapData(mapNumber:int) {
			stopScrolling();
			TileMap.removeTiles(mapClip);
			
			var map:Map = MapDatabase.getMap(mapNumber);
			mapCode = map.mapCode;
			mapName = map.mapName;
			
			var tileset:String = MapDatabase.getTilesetName(map.tilesetID);
			//-------------------------------######################
			var tileTypes:Array = MapDatabase.getTileTypes(map.tilesetID);
			
			TileMap.createTileMap(mapCode, 32, tileTypes, tileClings, "Tile");
			TileMap.addTiles(mapClip);

			var firstSep = mapCode.indexOf(":");
			var secSep = mapCode.indexOf(":", firstSep + 1);
			mapWidth = parseInt(mapCode.substring(firstSep + 1, secSep));
			mapHeight = parseInt(mapCode.substring(0, firstSep));
			
			// get map points
			clearAIUnits();
			preparePointArrays();
			
			// get teleport points
			var ind1 = 0;
			while (true) {
				ind1 = mapCode.indexOf("(", ind1) + 1;
				if (ind1 == 0)
					break;
				
				var ind2 = mapCode.indexOf(",", ind1);
				var ind3 = mapCode.indexOf(";", ind2 + 1);
				var ind4 = mapCode.indexOf(",", ind3 + 1);
				var ind5 = mapCode.indexOf(",", ind4 + 1);
				var ind6 = mapCode.indexOf(")", ind1);
				
				var teleX = parseInt(mapCode.substring(ind1, ind2));
				var teleY = parseInt(mapCode.substring(ind2 + 1, ind3));
				
				var destMap = parseInt(mapCode.substring(ind3 + 1, ind4));
				var destX = parseInt(mapCode.substring(ind4 + 1, ind5));
				var destY = parseInt(mapCode.substring(ind5 + 1, ind6));
				
				var mapX = (teleX + .5) * TileMap.TILE_SIZE;
				var mapY = (teleY + .5) * TileMap.TILE_SIZE;
				
				addTelePoint(mapX, mapY, teleX, teleY, destMap, new Point(destX, destY));
			}
			
			// get spawn points
			ind1 = 0;
			while (true) {
				ind1 = mapCode.indexOf("[", ind1) + 1;
				if (ind1 == 0)
					break;
				
				ind2 = mapCode.indexOf(",", ind1);
				ind3 = mapCode.indexOf(",", ind2 + 1);
				ind4 = mapCode.indexOf("]", ind3 + 1);
				
				var spawnx	= parseInt(mapCode.substring(ind1, ind2));
				var spawny	= parseInt(mapCode.substring(ind2 + 1, ind3));
				var spawnid	= parseInt(mapCode.substring(ind3 + 1, ind4));
				
				addSpawnPoint(spawnid, (spawnx + .5) * TileMap.TILE_SIZE, (spawny + .5) * TileMap.TILE_SIZE);
			}
		}
		static function preparePointArrays() {
			if (telePoints != null) {
				for (var a in telePoints) {
					var t = telePoints[a];
					removeFromMapClip(t);
				}
			}
			telePoints = new Array();
		}
		static function addTelePoint(mapX:Number, mapY:Number, teleX:int, teleY:int, destMap:int, destPoint:Point) {
			var tele = new TeleportPoint();
			tele.x = mapX;
			tele.y = mapY;
			tele.tx = teleX;
			tele.ty = teleY;
			tele.destMap = destMap;
			tele.destPoint = destPoint;
			
			addToMapClip(tele);
			telePoints.push(tele);
		}
		static function addSpawnPoint(spawnid:int, mapX:Number, mapY:Number) {
			var spawn = new AISpawnPoint(spawnid);
			spawn.x = mapX;
			spawn.y = mapY;
			spawn.setDeleteFunction(deleteEnemy);
			
			addToMapClip(spawn);
			aiUnits.push(spawn);
		}
		public static function setHeroPosition(hero:GameUnit, partner:GameUnit, startPoint:Point) {
			var sx = startPoint.x * TileMap.TILE_SIZE;
			var sy = startPoint.y * TileMap.TILE_SIZE;
			
			ScreenRect.setX(sx - ScreenRect.STAGE_WIDTH / 2);
			ScreenRect.setY(sy - ScreenRect.STAGE_HEIGHT / 2);
			
			hero.x = sx - TileMap.TILE_SIZE / 2;
			hero.y = sy;
			partner.x = sx + TileMap.TILE_SIZE / 2;
			partner.y = sy;
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