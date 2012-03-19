package db {
	import flash.events.Event;
	
	public class EnemyDatabase extends Database {
		static var names:Array, sprites:Array, hp:Array, speed:Array;
		
		public static function loadXML(url:String) {
			Database.loadXML(url, completeLoad);
		}
		public static function getHP(id:int) {
			return hp[id];
		}
		public static function getSpeed(id:int) {
			return speed[id];
		}
		public static function getSprite(id:int) {
			return "_sprites/" + sprites[id] + ".swf";
		}
		static function completeLoad(e:Event) {
			var dat = new XML(e.target.data);
			
			names	= new Array();
			sprites	= new Array();
			hp		= new Array();
			speed	= new Array();
			
			var id = 0;
			for each (var node:XML in dat.Enemy) {
				names.push(	node.Name);
				sprites.push(node.Sprite);
				hp.push(	parseInt(node.Health.attribute("Value")));
				speed.push(	parseInt(node.Speed.attribute("Value")));
				
				AbilityDatabase.addAbility(id++, node.Ability);
			}
		}
	}
	
}
