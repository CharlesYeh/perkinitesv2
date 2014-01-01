package game {
	import flash.geom.Point;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.display.Bitmap;
	
	import db.dbData.MapData;
	import db.dbData.TeleportData;
	import db.dbData.TilesetData;
	
	import game.Game;
	
	import tileMapper.InteractiveTile;
	import tileMapper.ScreenRect;
	import tileMapper.TileMap;
	
	import ui.Notification;

	import units.GameUnit;
	import units.StatUnit;
	import units.Teleport;
	
	import util.KeyDown;
	import units.Perkinite;
	
	public class MapManager {
		public static var world:World;
		
		// for cutscene scrolling
		public static var tileClings = new Array(false, false, false, true, true, false);

		public static var customClips:Array = new Array();

		public static function createWorld(mapName:String):World {
			resetWorld();
			
			var mdat:MapData = Game.dbMap.getMapData(mapName);
			var tdat:TilesetData = mdat.tilesetData;
			Game.playerProgress.map = mapName;
			
			if (world == null) {
				world = new World(mdat);
			}
			else{
				world.createWorld(mdat);
			}
			
			Game.overlay.locationDisplay.txtMessage.text = mdat.name;
			
			// reset camera
			ScreenRect.createScreenRect(new Array(world), GameConstants.WIDTH, GameConstants.HEIGHT);
			
			//make sure that on continue game, it doesn't start at the beginning
			var avgX:Number = 0;
			var avgY:Number = 0;
			
			for(var i = 0; i < Game.team.length; i++){
				world.addUnit(Game.team[i]);
				Game.team[i].setAbilityTargets(world.getEnemies()); //make it so that enemies will take damage
				Game.team[i].visible = (i == Game.playerIndex);
				
				if(i != Game.playerIndex) {
					Game.team[i].x = -1000;
					Game.team[i].y = -1000;
				}
			}
			
			var perkinite = Game.team[Game.playerIndex];
			var u:StatUnit = perkinite; //allow to end dashing by changing gameunit -> statunit
				
			avgX += u.x;
			avgY += u.y;
			
			var sx = avgX - GameConstants.WIDTH / 2;
			var sy = avgY - GameConstants.HEIGHT / 2;
			ScreenRect.setX(sx);
			ScreenRect.setY(sy);	
			
			var prefix:String = "tiles.Tile_" + tdat.id + "_";
			TileMap.createTileMap(mdat.code, mdat.height, mdat.width, GameConstants.TILE_SIZE, tdat.types, tdat.clings, prefix);
			
			// render tiles into map
			TileMap.addTiles(world.getTilesClip());
			
			//I have no idea what is going on
			TileMap.addObjects(mdat.objects, world.getTilesClip());
			
			return world;
		}
		
		public static function resetWorld():void {
			if (world != null) {
				world.clearWorld();
				TileMap.removeTiles(world.getTilesClip());
				TileMap.removeTiles(world.getTilesClip());
			}
			
			InteractiveTile.resetTiles();
		}
		
		public static function checkTeleports():void {
			var su:GameUnit = Game.perkinite;
			
			var map:TeleportData = world.checkTeleports(su);
			if (map != null) {
				// change map
				Game.playerProgress.setCreatedUnits(new Array());
				changeMap(map);
			}
		}
		
		public static function changeMap(tdat:TeleportData):void {
			createWorld(tdat.exitMap);
						
			var avgX:Number = 0;
			var avgY:Number = 0;
			
			var START_SEPARATION:int = 15;
			var u:StatUnit = Game.perkinite; //allow to end dashing by changing gameunit -> statunit
			
			u.x = tdat.exitX * GameConstants.TILE_SIZE + (GameConstants.TILE_SIZE >> 1);
			u.y = tdat.exitY * GameConstants.TILE_SIZE + (GameConstants.TILE_SIZE >> 1);
			//prevent any movement from the last map
			u.clearPath();
			
			//prevent dashing
			u.enableMovement();
			u.endAbility();
			avgX += u.x;
			avgY += u.y;	
			
			var sx = avgX - GameConstants.WIDTH / 2;
			var sy = avgY - GameConstants.HEIGHT / 2;
			ScreenRect.setX(sx);
			ScreenRect.setY(sy);			
		}
		
		public static function update():void {
			// Update ScreenRect position.
			var avgX:Number = 0;
			var avgY:Number = 0;
			
			var u:StatUnit = Game.perkinite;
			avgX = u.x;
			avgY = u.y;
			
			if(Game.customViewport) {
				avgX = Game.viewportPoint.x;
				avgY = Game.viewportPoint.y;
			}
			
			var sx = avgX - GameConstants.WIDTH / 2;
			var sy = avgY - GameConstants.HEIGHT / 2;
			ScreenRect.easeScreen(new Point(sx, sy));
			
			//Stay within bounds of map for ScreenRect.
			checkScreenRect();
			
			depthSortHandler();
			
			// Check to see if the leader unit walked into the teleport.
			checkTeleports();
			
			world.updateSequences();
			
		}
		
		public static function depthSortHandler():void {
			var depthArray:Array = new Array();
			var topArray:Array = new Array();
			var botArray:Array = new Array();
			var mapClip:MovieClip = world;
			
			for (var i:int = 0; i < mapClip.numChildren; i++) {
				var child:DisplayObject = mapClip.getChildAt(i);
				
/*				if (!(child is Bitmap) && ScreenRect.inBounds(child) && (child is Notification)) {
					topArray.push(mapClip.getChildAt(i));
				}*/
				if (!(child is Bitmap) && ScreenRect.inBounds(child)) {
					depthArray.push(mapClip.getChildAt(i));
				}
			}
			
			
			topArray.sortOn("y", Array.NUMERIC);
			depthArray.sortOn("y", Array.NUMERIC);
			botArray.sortOn("y", Array.NUMERIC);
			
			//depthArray = botArray.concat(depthArray).concat(topArray);
			var t:int = mapClip.numChildren;
			i = depthArray.length;
			while (i--) {
				t--;
				if (mapClip.getChildIndex(depthArray[i]) != t) {
					mapClip.setChildIndex(depthArray[i], t);
				}
			}
		}
		
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