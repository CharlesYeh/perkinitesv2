package game {
	
	public class Perkinite extends StatUnit {
		
		public function Perkinite(id) {
			// constructor code
			super();
			
			ID = id;
		}
		override protected function getSprite() {
			return new URLRequest(CharacterDatabase.getCharSprite(id));
		}
	}
	
}
