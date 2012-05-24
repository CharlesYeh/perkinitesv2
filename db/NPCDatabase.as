package db
{

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.xml.*;
	import game.Map;
	import game.NPCUnit;

	public class NPCDatabase
	{

		public static var npcMaps:Array;// NPCs on a map

		/**
		 * Loads the NPCs.
		 */
		public static function loadXML(url:String) {
			Database.loadXML(url, completeLoad);
		}
		static function completeLoad(e:Event) {
			var dat:XML = new XML(e.target.data);
			
			npcMaps = new Array();
			
			/*** First deal with entire maps that contain NPCs ***/
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
	}

}