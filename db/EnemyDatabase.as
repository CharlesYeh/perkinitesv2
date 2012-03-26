package db {
	import flash.events.Event;
	
	public class EnemyDatabase extends Database {
		static var ai:Array, names:Array, sprites:Array, hp:Array, speed:Array;
		static const ENEMY_ID_START = 10000;
		
		public static function loadXML(url:String) {
			Database.loadXML(url, completeLoad);
		}
		public static function getAI(id:int):String {
			return ai[id]
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
			
			ai		= new Array();
			names	= new Array();
			sprites	= new Array();
			hp		= new Array();
			speed	= new Array();
			
			var id = ENEMY_ID_START;
			for each (var node:XML in dat.Enemy) {
				ai.push(	node.AIClass);
				names.push(	node.Name);
				sprites.push(node.Sprite);
				hp.push(	parseInt(node.Health.attribute("Value")));
				speed.push(	parseInt(node.Speed.attribute("Value")));
				
				AbilityDatabase.addAbility(id++, node.Ability);
			}
		}
	}
	
}
