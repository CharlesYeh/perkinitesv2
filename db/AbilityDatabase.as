package db {
	import flash.events.Event;
	import flash.xml.XMLNode;
	import flash.display.Loader;
	import flash.net.URLRequest;
	
	public class AbilityDatabase {
		
		public static var abilities:Object = new Object();
		
		public static const ATKTYPE_TARGET:String	= "Target";	// single target click
		public static const ATKTYPE_POINT:String	= "Point";	// show aoe point
		public static const ATKTYPE_SSHOT:String	= "Skillshot";	// show arrow
		public static const ATKTYPE_SCAST:String	= "Smartcast";	// smart cast
		public static const ATKTYPE_CONE:String		= "Cone";	// show cone
		
		public static function addAbility(unitID:int, node) {
			abilities[unitID] = new Array();
			
			// add all abilities for this character (unitID)
			for (var d in node) {
				var data = new Object();
				var nodeData = node[d];
				
				var iconURL:URLRequest = new URLRequest(nodeData.Icon);
				var ic:Loader = new Loader();
				ic.load(iconURL);
				
				data.icon = ic;
				data.name = nodeData.Name;
				data.type = nodeData.Type;
				data.description = nodeData.Description;
				
				data.Range		= nodeData.Range.attribute("Value");
				data.MovementRadius	= nodeData.MovementRadius;
				data.StopAtEnemy= (nodeData.StopAtEnemy == "True") ? true : false;
				
				data.AOEDamage	= nodeData.AOE.attribute("Damage");
				data.AOERange	= nodeData.AOE.attribute("Range");
				data.SkillshotWidth	= nodeData.Skillshot.attribute("Width");
				data.SkillshotSpeed	= nodeData.Skillshot.attribute("Speed");
				
				data.Cooldown	= nodeData.Cooldown.attribute("Value");
				data.Damage		= nodeData.Damage.attribute("Value");
				
				abilities[unitID].push(data);
			}
		}
		public static function getName(index:int, id:int):String {
			return abilities[index][id].name;
		}
		public static function getTargetType(char:int, ability:int):String {
			return abilities[char][ability].type;
		}
		public static function getDescription(index:int, id:int):String {
			return abilities[index][id].description;
		}
		public static function getIcon(index:int, id:int):Loader {
			return abilities[index][id].icon;
		}
		public static function getAttribute(index:int, id:int, attr:String) {
			return abilities[index][id][attr];
		}
	}
	
}
