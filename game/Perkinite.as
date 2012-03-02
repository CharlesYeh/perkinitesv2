package game {
	import flash.net.URLRequest;
	import db.ActorDatabase;
	
	public class Perkinite extends StatUnit {
		public function Perkinite(id) {
			super();
			
			ID = id;
			
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
