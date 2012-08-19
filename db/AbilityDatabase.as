package db {
	import flash.utils.getDefinitionByName;
	import flash.utils.Dictionary;
	
	import db.dbData.AttackData;
	import attacks.*;
	
	public class AbilityDatabase {
		/** package where all the attack definitions are */
		public static const ABILITY_PACKAGE:String = "attacks.";
		
		/** compile these classes for attack types */
		public static const abilityClasses:Array = new Array(AttackSkillshot, AttackPoint, AttackDashSkillshot, AttackCone);
		
		/** dictionary of "name" -> "class definition" */
		public static var abilityByName:Dictionary = new Dictionary();
		
		/** dictionary of "name" -> "instance" */
		public static var abilities:Dictionary = new Dictionary();
		
		/**
		 * Returns the AttackData instance for this ability
		 */
		public static function getAbility(abilityData:Object):AttackData {
			var abilityName = abilityData.name;
			
			if (!abilities.hasOwnProperty(abilityData)) {
				abilities[abilityName] = AttackData.createAttack(abilityData);
			}
			
			return abilities[abilityName];
		}
		
		/**
		 * Returns the definition for an attack type
		 */
		public static function getAbilityClass(abilityName:String):Class {
			return getDefinitionByName(ABILITY_PACKAGE + abilityName) as Class;
		}
	}
}