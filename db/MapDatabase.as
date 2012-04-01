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
		public static function loadXML(url:String) {
			Database.loadXML(url, completeLoad);
		}
		static function completeLoad(e:Event) {
			var dat = new XML(e.target.data);
			
			names	= new Array();
			sprites	= new Array();
			hp		= new Array();
			hpup	= new Array();
			speed	= new Array();
			speedup	= new Array();
			wpn		= new Array();
			
			
			var id = 0;
			tilesets = new Array(dat.Tileset.length);
			for (var node:XML in dat.Tileset) {
				tilesets[id++] = node.split(";");
			}
			
			id = 0;
			maps = new Array(dat.Map.length);
			for (var node:XML in dat.Map) {
				var mapid	= node.ID;
				var mapcode	= node.MapCode;
				var mapname	= node.MapName;
				var tileset	= node.TilesetID;
				var bgm		= node.BGM;
				var bgs		= node.BGS;
				
				maps[id++] = new Map(mapid, mapcode, mapname, tileset, bgm, bgs);
			}
		}
		
		public static function getMap(i:Number):Map {
			return maps[i];
		}
		//----------------TILES-----------------
		public static function getTileTypes(i:Number) {
			switch (i) {
			case 0: return new Array("s", "f", "w", "w", "w", "w");
			case 1: return new Array("s", "f", "w", "w", "w", "w");
			case 2: return new Array("s", "f", "w", "w", "w", "w");
			case 3: return new Array("s", "f", "w", "w", "w", "w");
			}
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