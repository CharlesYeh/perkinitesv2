package db.dbData {
	import db.AbilityDatabase;
	
	public class CharacterData implements DatabaseData {
		
		public var name:String;
		public var id:String;
		public var sprite:String;
		
		public var health:int;
		public var defense:int;
		public var speed:int;
		public var weapon:String;
		
		/** contains the grants to be given upon each level up */
		public var levelBonuses:Object;
		
		public var abilities:Array;
		
		public function parseData(obj:Object):void {
			name	= obj.name;
			id		= obj.id;
			sprite	= obj.sprite;
			
			health	= obj.health;
			defense	= obj.defense;
			speed	= obj.speed;
			weapon	= obj.weapon;
			
			levelBonuses= obj.levelBonuses;
			
			abilities = new Array();
			for (var index:String in obj.abilities) {
				var abilityName:Object = obj.abilities[index];
				abilities.push(AbilityDatabase.getAbility(abilityName));
			}
		}
	}
}