﻿package game {

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.xml.*;
	import flash.sampler.StackFrame;
	
	public class MapDatabase {

		public var xmlLoader:URLLoader = new URLLoader();

		public const tilesetsURL:String	= "_xml/Tilesets.xml";
		public const mapsURL:String		= "_xml/Maps.xml";
		public const mapObjectsURL:String = "_xml/Maps/Map";

		public static var tilesetInfo = new Array();
		public static var mapInfo = new Array();
		public static var mapObjectInfo = new Array();

		/**
		 * Loads the tilesets, maps, and objects.
		 */
		
		public static function getMapName(i:Number):String {
			switch (i) {
			case 0:	return "Perkins1";
			case 1:	return "Perkins2";
			case 2:	return "Perkins3";
			case 3:	return "Perkins4";
			}
		}
		
		public static function getMapCode(i:Number):String {
			switch (i) {
			case 0:	return "31:71:333333333333333333333333333333333333333333333333333333333333333333333333444434444344443444434444333333333333333333333444434444344443444434444334444344443444434444344443333333333333333333334444344443444434444344443300003000030000300003000033333333333333333333300003000030000300003000033000030000300003000030000333333333333333333333000030000300003000030000330000300003000030000300003333333333333333333330000300003000030000300003333333333333333333333333334444344443444434444333333333333333333333333333444444444444444444444444344443444434444344443444444444444444444444444335555555555555555555555553000030000300003000035555555555555555555555553300000000000000000000000030000300003000030000300000000000000000000000033000000000000000000000000300003000030000300003000000000000000000000000333333333333333303333030003333333333333333333330003033330333333333333333344443333333333333333300044444444444444444444400033333333333333333444433444433333333333333333000555555555555555555555000333333333333333334444330000333333333333333330000000000000000000000000003333333333333333300003300003333333333333333300000000000000000000000000033333333333333333000033000033333333333333333000303333333330000333303000333333333333333330000333333333333333333333330003444433333300003444430003333333333333333333333344444444444444444444400034444333333333334444300044444444444444444444433555555555555555555555000300003333333333300003000555555555555555555555330000000000000000000000003000033333333333000030000000000000000000000003300000000000000000000000030000333333333330000300000000000000000000000033333030333303333033330333333333333333333333333333033330333303333030333334444344443444434444344443333333333333333333334444344443444434444344443344443444434444344443444433333333333333333333344443444434444344443444433000030000300003000030000333333333333333333333000030000300003000030000330000300003000030000300003333333333333333333330000300003000030000300003300003000030000300003000033333333333333333333300003000030000300003000033333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333330000000000000000000000000000000(66,20)";
			case 1:
				
				break;
			case 2:
				
				break;
			}
		}
		
		
		//----------------TILES-----------------
		public static function getTileTypes(i:Number) {
			switch (i) {
			case 0: return new Array("w", "f");
			case 1: return new Array("w", "f");
			case 2: return new Array("w", "f");
			case 3: return new Array("w", "f");
			}
		}
		/*public function loadData() {
			this.loadObject(tilesetsURL, handleLoadedTilesets);
			this.addEventListener(MapDataEvent.TILESETS_LOADED, loadMaps);
			this.addEventListener(MapDataEvent.MAPS_LOADED, loadMapObjects);
		}*/

		/**
		 * Creates a request using the passed URL and calls the passed function on complete.
		 *
		 * @param url The URL to request.
		 * @param handleFunction The function to be called on complete.
		 */

		/*public function loadObject(url:String, handleFunction:Function):void {
			var request:URLRequest=new URLRequest(url);
			xmlLoader.addEventListener(Event.COMPLETE, handleFunction);
			xmlLoader.load(request);
		}*/

		/**
		 * Loads the tilesets.
		 */
		/*public function handleLoadedTilesets(e:Event):void {
			xmlLoader.removeEventListener(Event.COMPLETE, handleLoadedTilesets);
			var xmlData=new XML(e.target.data);
			parseTilesetData(xmlData);
		}
		public function parseTilesetData(input:XML):void {
			for each (var tilesetElement:XML in input.Tileset) {
				var tileset = new Tileset();
				tileset.ID=tilesetElement.ID;
				tileset.picture=tilesetElement.Picture;

				for each (var tileElement:XML in tilesetElement.Tile) {
					tileset.tileTypes.push(""+tileElement.Type);
				}

				tilesetInfo.push(tileset);
			}
			this.dispatchEvent(new MapDataEvent(MapDataEvent.TILESETS_LOADED, true));
		}*/

		/**
		 * Loads the maps after loading tilesets.
		 */
		/*public function loadMaps(e:MapDataEvent):void {
			loadObject(mapsURL, this.handleLoadedMaps);
		}
		public function handleLoadedMaps(e:Event):void {
			xmlLoader.removeEventListener(Event.COMPLETE, handleLoadedMaps);
			var xmlData=new XML(e.target.data);
			parseMapData(xmlData);
		}
		public function parseMapData(input:XML):void {
			for each (var mapElement:XML in input.Map) {
				var map = new Map(mapElement.ID, mapElement.MapCode, mapElement.MapName, 
				  mapElement.TilesetID, mapElement.BGM, mapElement.BGS);
				mapInfo.push(map);
			}
			this.dispatchEvent(new MapDataEvent(MapDataEvent.MAPS_LOADED, true));
		}*/

		/**
		 * Loads the objects on the maps after loading maps.
		 */
		/*public function loadMapObjects(e:MapDataEvent):void {
			var objectXMLLoaders:Array = new Array();

			for (var i = 0; i < mapInfo.length; i++) {
				var oXMLLoader:URLLoader = new URLLoader();
				objectXMLLoaders.push(oXMLLoader);
			}

			for (var j = 0; j< mapInfo.length; j++) {
				objectXMLLoaders[j].addEventListener(Event.COMPLETE, handleLoadedMapObjects);
				objectXMLLoaders[j].load(new URLRequest(mapObjectsURL+(j+1)+".xml"));
			}
		}
		public function handleLoadedMapObjects(e:Event):void {
			e.target.removeEventListener(Event.COMPLETE, handleLoadedMapObjects);
			var xmlData=new XML(e.target.data);
			parseMapObjectData(xmlData);
		}
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

		public static function getTileset(id:int):Tileset {
			return tilesetInfo[id];
		}
		public static function getMap(id:int):Map {
			return mapInfo[id];
		}
		public static function getMapObjects(id:int):Array {
			return mapObjectInfo[id];
		}*/
	}

}