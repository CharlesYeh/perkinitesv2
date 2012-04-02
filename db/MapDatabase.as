package db {

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.xml.*;
	import game.Map;
	
	public class MapDatabase {
		
		public static var maps:Array;		// map objects
		
		public static var setnames:Array;
		public static var tilesets:Array;

		/**
		 * Loads the tilesets, maps, and objects.
		 */
		public static function loadXML(urlsets:String, urlmaps:String) {
			Database.loadXML(urlsets, completeTilesetLoad);
			Database.loadXML(urlmaps, completeMapLoad);
		}
		static function completeTilesetLoad(e:Event) {
			var dat:XML = new XML(e.target.data);
			
			setnames = new Array();
			tilesets = new Array();
			
			for (var nn in dat.Tileset) {
				var node = dat.Tileset[nn];
				
				setnames.push(node.Name);
				tilesets.push(node.Types.split(";"));
			}
		}
		static function completeMapLoad(e:Event) {
			var dat:XML = new XML(e.target.data);
			
			maps = new Array();
			
			for (var nn in dat.Map) {
				var node = dat.Map[nn];
				
				var mapid	= node.ID;
				var mapcode	= node.MapCode;
				var mapname	= node.MapName;
				var tileset	= node.TilesetID;
				var bgm		= node.BGM;
				var bgs		= node.BGS;
				
				maps.push(new Map(mapid, mapcode, mapname, tileset, bgm, bgs));
			}
		}
		
		public static function getMap(i:Number):Map {
			return maps[i];
		}
		//----------------TILES-----------------
		public static function getTileTypes(i:Number) {
			return tilesets[i];
		}
		public static function getTilesetName(i:Number):String {
			return setnames[i];
		}
		/*
		public function parseMapObjectData(input:XML):void {
			var eventArray = new Array();

			for each (var eventElement:XML in input.MapObject) {
				var mapEvent = new MapObject();

				mapEvent.dir=eventElement.Graphic.Dir;

				var posString=eventElement.Graphic.Position;
				var ind1=posString.indexOf("(")+1;
				var ind2=posString.indexOf(",",ind1);
				mapEvent.xTile=parseInt(posString.substring(ind1,ind2));
				mapEvent.x=mapEvent.xTile*32+16;
				ind1=ind2+1;
				ind2=posString.indexOf(")");
				mapEvent.yTile=parseInt(posString.substring(ind1,ind2));
				mapEvent.y=mapEvent.yTile*32+16;
				
				mapEvent.mxpos = mapEvent.x; //ugh this stupid bug took forever to find 
				mapEvent.mypos = mapEvent.y;

				for each (var conditionElement:XML in eventElement.Conditions.children()) {
					mapEvent.conditions.push(conditionElement);
				}

				mapEvent.movement=eventElement.Movement.Type;
				mapEvent.speed=eventElement.Movement.Speed;
				mapEvent.moveWait=eventElement.Movement.Wait;

				mapEvent.aTrigger=eventElement.Activation.Trigger;
				mapEvent.range=eventElement.Activation.Range;

				for each (var commandElement:XML in eventElement.Commands.children()) {
					var action=MapObjectParser.parseCommand(mapEvent,commandElement);
					mapEvent.commands.push(action);
				}
				eventArray.push(mapEvent);
			}
			mapObjectInfo.push(eventArray);
			this.dispatchEvent(new MapDataEvent(MapDataEvent.MAPOBJECTS_LOADED, true));
		}
		*/
	}

}