package units {
	import flash.net.URLRequest;
	
	import db.dbData.CharacterData;
	
	public class Perkinite extends StatUnit {
		public function Perkinite(charData:CharacterData) {
			super(charData);
			
			progressData.health = unitData.health;
			setSpeed(unitData.speed);
			
			// load swf
			loadSwf();
		}
	}
}
