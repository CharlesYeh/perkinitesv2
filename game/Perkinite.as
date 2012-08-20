package game {
	import flash.net.URLRequest;
	
	import db.ActorDatabase;
	
	import db.dbData.CharacterData;
	
	public class Perkinite extends StatUnit {
		public function Perkinite(charData:CharacterData) {
			super(charData);
			
			healthPoints = healthMax = ActorDatabase.getHP(ID);
			setSpeed(ActorDatabase.getSpeed(ID));
			
			// load swf
			loadSwf();
		}
		override protected function getSprite() {
			return new URLRequest(ActorDatabase.getCharSprite(ID));
		}
	}
}
