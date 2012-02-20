package db {
	import flash.events.Event;
	import flash.xml.XMLNode;
	import flash.display.Loader;
	import flash.net.URLRequest;
	
	public class AbilityDatabase {
		
		public static var abilities:Object = new Object();
		
		public static const ATKTYPE_TARGET:int = 0;
		public static const ATKTYPE_POINT:int	= 1;
		public static const ATKTYPE_SSHOT:int	= 2;
		
		static const targetTypes = {0: [ATKTYPE_TARGET, ATKTYPE_TARGET],
									1: [ATKTYPE_TARGET, ATKTYPE_TARGET],
									2: [ATKTYPE_TARGET, ATKTYPE_TARGET],
									3: [ATKTYPE_TARGET, ATKTYPE_TARGET],
									4: [ATKTYPE_TARGET, ATKTYPE_TARGET],
									5: [ATKTYPE_TARGET, ATKTYPE_TARGET],
									6: [ATKTYPE_TARGET, ATKTYPE_TARGET],
									7: [ATKTYPE_TARGET, ATKTYPE_TARGET],
									8: [ATKTYPE_TARGET, ATKTYPE_TARGET],
									9: [ATKTYPE_TARGET, ATKTYPE_TARGET]}
		
		public static function getTargetType(char:int, ability:int) {
			return targetTypes[char][ability];
		}
		
		public static function addAbility(unitID:int, node) {
			abilities[unitID] = new Array();
			
			for (var d in node) {
				var data = new Object();
				var nodeData = node[d];
				
				var ic:Loader = new Loader();
				ic.load(new URLRequest(nodeData.Icon));
				
				data.icon = ic;
				data.name = nodeData.name;
				data.description = "some description goes here";
				abilities[unitID].push(data);
			}
		}
		public static function getName(index:int, id:int) {
			return abilities[index][id].name;
		}
		public static function getDescription(index:int, id:int) {
			return "some description goes here";
		}
		public static function getIcon(index:int, id:int) {
			return abilities[index][id].icon;
		}
	}
	
}
