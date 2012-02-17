package db {
	import flash.events.Event;
	
	public class AbilityDatabase {
		
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
		public static function loadXML(url:String) {
			Database.loadXML(url, completeLoad);
		}
		static function completeLoad(e:Event) {
			var dat = new XML(e.target.data);
			/*
			names	= new Array();
			sprites	= new Array();
			hp		= new Array();
			hpup		= new Array();
			dmg		= new Array();
			dmgup	= new Array();
			speed	= new Array();
			speedup	= new Array();
			wpn		= new Array();
			
			for each (var node:XML in dat.Actor) {
				names.push(	node.Name);
				sprites.push(node.Sprite);
				hp.push(	parseInt(node.Health.attribute("Value")));
				hpup.push(	parseInt(node.Health.attribute("Increase")));
				dmg.push(	parseInt(node.Attack.attribute("Value")));
				dmgup.push(	parseInt(node.Attack.attribute("Increase")));
				speed.push(	parseInt(node.Speed.attribute("Value")));
				speedup.push(parseInt(node.Speed.attribute("Increase")));
				wpn.push(	node.Weapon);
			}*/
		}
	}
	
}
