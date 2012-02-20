package db{
	import flash.events.Event;
	/**
	 * Holds Actor information and maybe dispatches events to signal when loading is complete.
	 */
	public class ActorDatabase extends Database {
		static var names:Array;
		static var sprites:Array;
		static var hp:Array;
		static var hpup:Array;
		static var speed:Array;
		static var speedup:Array;
		static var wpn:Array;
		
		public static function getName(i:Number):String		{ return names[i];	}
		public static function getHP(i:Number):Number 		{ return hp[i];		}
		public static function getSpeed(i:Number):Number 	{ return speed[i];	}
		public static function getWeapon(i:Number):String	{ return wpn[i];	}
		
		public static function getUnlockedNames():Array {
			// CHANGE TO GIVE ONLY UNLOCKED TEAMS
			return names;
		}
		public static function getCharSprite(id:int) {
			return "_sprites/" + sprites[id] + ".swf";
		}
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