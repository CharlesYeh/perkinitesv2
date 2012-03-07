package db {
	import flash.events.Event;
	
	public class EnemyDatabase extends Database {
		static var names:Array, sprites:Array, hp:Array, hpup:Array, speed:Array, speedup:Array, wpn:Array;
		
		public function EnemyDatabase() {
			// constructor code
		}
		public static function loadXML(url:String) {
			Database.loadXML(url, completeLoad);
		}
		public static function getHP(id:int) {
			return 100;
		}
		public static function getSpeed(id:int) {
			return 100;
		}
		public static function getSprite(id:int) {
			return "_sprites/enemy_Drunk-Guy.swf";
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
			for each (var node:XML in dat.Actor) {
				names.push(	node.Name);
				sprites.push(node.Sprite);
				hp.push(	parseInt(node.Health.attribute("Value")));
				hpup.push(	parseInt(node.Health.attribute("Increase")));
				speed.push(	parseInt(node.Speed.attribute("Value")));
				speedup.push(parseInt(node.Speed.attribute("Increase")));
				wpn.push(	node.Weapon);
				
				AbilityDatabase.addAbility(id++, node.Ability);
			}
		}
	}
	
}
