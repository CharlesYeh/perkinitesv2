package db {
	import flash.utils.getDefinitionByName;
	import flash.utils.Dictionary;
	
	import db.dbData.AttackData;
	import attacks.*;
	import attacks.buffs.*;
	
	public class AbilityDatabase {
		public static const ABILITY_ICONS:String = "assets/icons/";
		
		/** package where all the attack definitions are */
		public static const ABILITY_PACKAGE:String = "attacks.";
		
		/** package where all the buff definitions are */
		public static const BUFF_PACKAGE:String = "attacks.buffs.";
		
		/** compile these classes for attack types */
		public static const abilityClasses:Array = new Array(AttackSkillshot, AttackPoint, AttackDashSkillshot, AttackCone, AttackSmartcast, AttackHomingProjectiles, AttackConsumeSmartcast, AttackLaser);
		
		/** compile these classes for buff types */
		public static const buffClasses:Array = new Array(BuffShield, BuffSpeed, BuffStun, BuffKnockback);
		
		public static function getBuffClass(buffName:String):Class {
			return getDefinitionByName(BUFF_PACKAGE + buffName) as Class;
		}
		
		/** dictionary of "name" -> "class definition" */
		public static var abilityByName:Dictionary = new Dictionary();
		
		/** dictionary of "name" -> "instance" */
		public static var abilities:Dictionary = new Dictionary();
		
		/**
		 * Returns the AttackData instance for this ability
		 */
		public static function getAbility(abilityData:Object):AttackData {
			var abilityName = abilityData.name;
			
			var ability = AttackData.createAttack(abilityData);
			
			if (!abilities.hasOwnProperty(abilityName)) {
				abilities[abilityName] = ability;
			}
			
			//return abilities[abilityName];
			return ability;
		}
		
		/**
		 * Returns the definition for an attack type
		 */
		public static function getAbilityClass(abilityName:String):Class {
			return getDefinitionByName(ABILITY_PACKAGE + abilityName) as Class;
		}
	}
}