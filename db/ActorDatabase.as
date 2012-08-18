package db{
	import flash.net.URLRequest;
	import flash.display.*;
	import flash.events.Event;
	/**
	 * Holds Actor information and maybe dispatches events to signal when loading is complete.
	 */
	public class ActorDatabase implements DatabaseLoader  {
		
		/** path relative to game of enemy jsons */
		public static const PATH:String = "assets/data/characters/";
		
		/** filename of file containing character json names */
		public static const BASE:String = "characters.json";
		
		static var names:Array;
		static var sprites:Array;
		static var hp:Array;
		static var hpup:Array;
		static var atk:Array;
		static var atkup:Array;
		static var speed:Array;
		static var speedup:Array;
		static var wpn:Array;
		
		static var icons:Array;
		
		public static function getName(i:Number):String		{ return names[i];	}
		public static function getHP(i:Number):Number 		{ return hp[i];		}
		public static function getAttack(i:Number):Number   { return atk[i];    }
		public static function getSpeed(i:Number):Number 	{ return speed[i];	}
		public static function getWeapon(i:Number):String	{ return wpn[i];	}
		public static function getIcon(i:Number):Loader		{ return icons[i];	}
		
		public static function getUnlockedNames():Array {
			// CHANGE TO GIVE ONLY UNLOCKED TEAMS
			return names;
		}
		public static function getCharSprite(id:int) {
			return "data/sprites/" + sprites[id] + ".swf";
		}
		public static function loadData():void {
			Database.loadData(url, completeLoad);
		}
		static function completeLoad(e:Event) {
			var dat = new XML(e.target.data);
			
			names	= new Array();
			sprites	= new Array();
			hp		= new Array();
			hpup	= new Array();
			atk     = new Array();
			atkup   = new Array();
			speed	= new Array();
			speedup	= new Array();
			wpn		= new Array();
			
			icons	= new Array();
			
			var id = 0;
			for each (var node:XML in dat.Actor) {
				names.push(	node.Name);
				sprites.push(node.Sprite);
				hp.push(	parseInt(node.Health.attribute("Value")));
				hpup.push(	parseInt(node.Health.attribute("Increase")));
				atk.push(	parseInt(node.Attack.attribute("Value")));
				atkup.push(	parseInt(node.Attack.attribute("Increase")));				
				speed.push(	parseInt(node.Speed.attribute("Value")));
				speedup.push(parseInt(node.Speed.attribute("Increase")));
				wpn.push(	node.Weapon);
				
				// load icon
				var iconURL:URLRequest = new URLRequest("_icons/Face Icon - " + node.Sprite + ".png");
				var ic:Loader = new Loader();
				ic.load(iconURL);
				
				icons.push(ic);
				
				AbilityDatabase.addAbility(id++, node.Ability);
			}
		}
	}
}