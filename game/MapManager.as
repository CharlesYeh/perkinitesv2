package game {
	import util.*;
	import tileMapper.*;
	
	import db.MapDatabase;
	
	import units.GameUnit;

	import flash.geom.Point;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.display.Bitmap;
	import flash.events.*;
	import flash.ui.*;
	
	import db.dbData.MapData;
	import db.dbData.TilesetData;
	import units.StatUnit;
	import db.dbData.TeleportData;
	import units.Teleport;

	public class MapManager {
		public static var world:World;
		
		// for cutscene scrolling
		public static var tileClings = new Array(false, false, false, true, true, false);

		public static var customClips:Array = new Array();

		/**
		 * @param	team	Array of StatUnits which are custom-added into the world
		 */
		public static function createWorld(mapName:String, team:Array):World {
			resetWorld();
			
			var mdat:MapData = Game.dbMap.getMapData(mapName);
			var tdat:TilesetData = mdat.tilesetData;
			
			if (world == null) {
				world = new World(mdat);
			}
			else{
				world.createWorld(mdat);
			}
			
			
			for (var i:String in team) {
				world.addUnit(team[i]);
				team[i].setAbilityTargets(world.getEnemies()); //make it so that enemies will take damage
			}
			
			// reset camera
			ScreenRect.createScreenRect(new Array(world), GameConstants.WIDTH, GameConstants.HEIGHT);
			
			var prefix:String = "tiles.Tile_" + tdat.id + "_";
			TileMap.createTileMap(mdat.code, mdat.height, mdat.width, GameConstants.TILE_SIZE, tdat.types, tdat.clings, prefix);
			
			// render tiles into map
			TileMap.addTiles(world.getTilesClip());
			
			return world;
		}
		
		public static function resetWorld():void {
			if (world != null) {
				world.clearWorld();
				TileMap.removeTiles(world.getTilesClip());
			}
			
			InteractiveTile.resetTiles();
		}
		
		public static function checkTeleports():void {
			var su:GameUnit = Game.team[0];
			
			var map:TeleportData = world.checkTeleports(su);
			if (map != null) {
				// change map
				changeMap(map);
			}
		}
		
		public static function changeMap(tdat:TeleportData):void {
			createWorld(tdat.exitMap, Game.team);
			
			// move team to exit location
			for (var i:String in Game.team) {
				var u:StatUnit = Game.team[i]; //allow to end dashing by changing gameunit -> statunit
				
				u.x = tdat.exitX * GameConstants.TILE_SIZE + (GameConstants.TILE_SIZE >> 1);
				u.y = tdat.exitY * GameConstants.TILE_SIZE + (GameConstants.TILE_SIZE >> 1);
				//prevent any movement from the last map
				u.clearPath();
				
				//prevent dashing
				u.enableMovement();
				u.endAbility();
			}
		}
		
		public static function update():void {
			var avgX:Number = 0;
			var avgY:Number = 0;
			
			for (var i:String in Game.team) {
				var u:StatUnit = Game.team[i];
				avgX += u.x;
				avgY += u.y;
			}
			
			avgX /= Game.team.length;
			avgY /= Game.team.length;
			
			var sx = avgX - GameConstants.WIDTH / 2;
			var sy = avgY - GameConstants.HEIGHT / 2;
			ScreenRect.easeScreen(new Point(sx, sy));
			
			checkScreenRect();
			depthSortHandler();
			
			world.updateSequences();
		}
		
		public static function depthSortHandler():void {
			var depthArray:Array = new Array();
			var mapClip:MovieClip = world;
			
			for (var i:int = 0; i < mapClip.numChildren; i++) {
				var child:DisplayObject = mapClip.getChildAt(i);
				
				if (!(child is Bitmap) && ScreenRect.inBounds(child)) {
					depthArray.push(mapClip.getChildAt(i));
				}
			}
			
			depthArray.sortOn("y", Array.NUMERIC);
			
			var t:int = mapClip.numChildren;
			i = depthArray.length;
			while (i--) {
				t--;
				if (mapClip.getChildIndex(depthArray[i]) != t) {
					mapClip.setChildIndex(depthArray[i], t);
				}
			}
		}
		
		/*
		//-------------AI UNITS-------------\
		public static function clearNPCUnits(){
			for (var n in npcUnits){
				var npc = npcUnits[n];
				removeFromMapClip(npc);
				npc.destroy();
			}
			
			npcUnits = new Array();
		}
		
		public static function deleteSpawn(u:AISpawnPoint) {
			deleteEnemy(u);
			if (u.healthPoints <= 0 && u.destroyable) {
				// was destroyed, remove permanently?
				sObject.data[FINISH_SPAWN + u.map + "_" + u.ptID] = true;
			}
		}
		
		// remove self from public array of units
		public static function deleteEnemy(u:StatUnit) {
			aiUnits.splice(aiUnits.indexOf(u), 1);
			removeFromMapClip(u);
		}
		
		public static function getAIUnits():Array {
			//return aiUnits;
			return null;
		}
		//-----------END AI UNITS-----------
		public static function addToMapClip(mc:MovieClip) {
			mapClip.addChild(mc);
		}
		public static function removeFromMapClip(mc:MovieClip) {
			mapClip.removeChild(mc);
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
		
		static function preparePointArrays() {
			if (telePoints != null) {
				for (var a in telePoints) {
					var t = telePoints[a];
					removeFromMapClip(t);
				}
			}
			telePoints = new Array();
		}
		static function addSpawnPoint(spawnid:int, mapX:Number, mapY:Number, ptID:int, destroy:Boolean) {
			var spawn = new AISpawnPoint(spawnid);
			spawn.x = mapX;
			spawn.y = mapY;
			
			// for permanent destroying
			spawn.destroyable = destroy;
			spawn.map = mapNumber;
			spawn.ptID = ptID;
			
			spawn.setDeleteFunction(deleteSpawn);
			
			addToMapClip(spawn);
			aiUnits.push(spawn);
		}
		static function addNPC(npc:NPCUnit, mapX:Number, mapY:Number){
			npc.x = mapX;
			npc.y = mapY;
			addToMapClip(npc);
			npcUnits.push(npc);
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
			var e = new Enemy(5);
			mapClip.addChild(e);
			e.x = 4 * 32 + 16;
			e.y = 9 * 32 + 16;
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
			//scrolling = false;
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
		*/
		private static function checkScreenRect():void {
			if (ScreenRect.getX() < 0) {
				ScreenRect.setX(0);
			}
			if (ScreenRect.getY() < 0) {
				ScreenRect.setY(0);
			}
			if (ScreenRect.getX() + 640 > world.mapData.width * GameConstants.TILE_SIZE) {
				ScreenRect.setX(world.mapData.width * GameConstants.TILE_SIZE - GameConstants.WIDTH);
			}
			if (ScreenRect.getY() + 480 > world.mapData.height * GameConstants.TILE_SIZE) {
				ScreenRect.setY(world.mapData.height * GameConstants.TILE_SIZE - GameConstants.HEIGHT);
			}
		}
	}
}