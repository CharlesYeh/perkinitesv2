package db {
	
	public class AbilityDatabase {
		
		public static const ATKTYPE_TARGET:int = 0;
		public static const ATKTYPE_POINT:int	= 1;
		public static const ATKTYPE_AOE:int	= 2;
		public static const ATKTYPE_SSHOT:int	= 3;
		
		static const targetTypes = {0: [ATKTYPE_TARGET, ATKTYPE_TARGET],
									1: [ATKTYPE_TARGET, ATKTYPE_TARGET],
									2: [ATKTYPE_TARGET, ATKTYPE_TARGET],
									3: [ATKTYPE_TARGET, ATKTYPE_TARGET],
									4: [ATKTYPE_TARGET, ATKTYPE_TARGET],
									5: [ATKTYPE_TARGET, ATKTYPE_TARGET],
									6: [ATKTYPE_TARGET, ATKTYPE_TARGET],
									7: [ATKTYPE_TARGET, ATKTYPE_TARGET],
									8: [ATKTYPE_TARGET, ATKTYPE_TARGET],
									9: [ATKTYPE_TARGET, ATKTYPE_TARGET]}
		
		public function AbilityDatabase() {
			// constructor code
		}
		public static function getTargetType(char:int, ability:int) {
			return targetTypes[char][ability];
		}
	}
	
}
