package db
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.xml.*;
	import game.Map;
	import game.NPCUnit;

	public class NPCDatabase extends Database
	{

		public static var npcMaps:Array;// NPCs on a map
		public static var icons:Array;// faceicons for messages

		/**
		 * Loads the NPCs.
		 */
		public static function loadXML(url:String) {
			Database.loadXML(url, completeLoad);
		}
		static function completeLoad(e:Event) {
			var dat:XML = new XML(e.target.data);
			
			npcMaps = new Array();
			icons = new Array();
			
			/*** First deal with face icons ***/
			for (var n in dat.Icons.children()){
				var fnode = dat.Icons.children()[n];
				var iconURL:URLRequest = new URLRequest("_icons/Face Icon - " + fnode + ".png");
				var ic:Loader = new Loader();
				ic.load(iconURL);
				
				icons[fnode] = ic;
			}
			
			/*** Then deal with entire maps that contain NPCs ***/
			for (var nn in dat.NPCMap){
				var node = dat.NPCMap[nn];
				
				var npcs = new Array();
				
				/*** Deal with NPCs in the maps ***/
				for (var np in node.NPC){
					var npcNode = node.NPC[np];
					
					var npc = new NPCUnit(npcNode.Sprite);
					npc.moveDir = npcNode.Direction;
					npc.xpos = npcNode.XPos;
					npc.ypos = npcNode.YPos;
					/*** Deal with their conditions ***/
					
					/*** Deal with their commands ****/
					for (var com in npcNode.Commands.children()){
						npc.commands.push(npcNode.Commands.children()[com]);
					}
					
					npcs.push(npc);
				}
				npcMaps.push(npcs); 			//npcMaps[int(node.ID)] = npcs;
			}			
		}

		public static function getNPCMap(i:Number):Array {
			if (i < npcMaps.length){
				return npcMaps[i];
			}
			else{
				return [];
			}
		}
		public static function getFaceIcon(unit:String):Loader {
			return icons[unit];
		}		
	}

}