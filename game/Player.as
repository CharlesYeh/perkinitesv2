package game {
	
	public class Player {
		static var flexPoints:Number;
		
		public static function getFlexPoints() {
			return flexPoints;
		}
		public static function setFlexPoints(p) {
			flexPoints = Math.min(Math.max(p, 0), 999999);
		}
	}
	
}
