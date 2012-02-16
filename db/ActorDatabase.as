package db{
	
	/**
	 * Holds Actor information and maybe dispatches events to signal when loading is complete.
	 */
	public class ActorDatabase {
		// hard-code now for simplicity
		static const names	= new Array("Charles Y.", "Nate M.", "C. Kata", "Cia M.", "Eric H.", "John-Tran", "Huong V.", "Huilian Q.");
		static const CHAR_SPRITES = new Array("CY", "NM", "CK", "CM", "JT", "EH", "HV", "HQ");
		static const hp		= new Array(75, 100, 75, 60, 110, 65, 70, 70);
		static const dmg	= new Array(3, 5, 4, 2, 5, 3, 3, 3);
		static const speed	= new Array(360, 264, 288, 312, 360, 432, 312, 336);
		static const wpn	= new Array("Shinai", "Claws", "Railgun", "Magic Wand", "Tentacles", "Hoverpad", "Megaphone", "Microphone");
		
		public static function getName(i:Number):String		{ return names[i];	}
		public static function getHP(i:Number):Number 		{ return hp[i];		}
		public static function getDmg(i:Number):Number 		{ return dmg[i];	}
		public static function getSpeed(i:Number):Number 	{ return speed[i];	}
		public static function getWeapon(i:Number):String	{ return wpn[i];	}
		
		public static function getUnlockedNames():Array {
			// CHANGE TO GIVE ONLY UNLOCKED TEAMS
			return names;
		}
		public static function getCharSprite(id:int) {
			return "_sprites/" + CHAR_SPRITES[id] + ".swf";
		}
	}
}