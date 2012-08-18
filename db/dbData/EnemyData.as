package db.dbData {
	import attacks.Attack;
	
	public class EnemyData implements DatabaseData {
		
		public var name:String;
		public var id:String;
		public var sprite:String;
		public var ai:String;
		
		public var health:int;
		public var defense:int;
		public var speed:int;
		public var abilities:Array;
		
		public static function parseData(obj:Object):DatabaseData {
			var enemy:EnemyData = new EnemyData();
			enemy.name		= obj.name;
			enemy.id		= obj.id;
			enemy.sprite	= obj.sprite;
			enemy.ai		= obj.ai;
			
			enemy.health	= obj.health;
			enemy.defense	= obj.defense;
			enemy.speed		= obj.speed;
			
			enemy.abilities = new Array();
			for (var abilityName:String in obj.abilities) {
				enemy.abilities.push(AttackData.parseData(obj.abilities[abilityName]));
			}
			
			return EnemyData
		}
	}
}