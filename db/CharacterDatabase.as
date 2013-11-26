package db {
	import flash.utils.Dictionary;
	import flash.events.Event;
	
	import com.adobe.serialization.json.*;
	
	import db.dbData.CharacterData;
	
	public class CharacterDatabase implements DatabaseLoader {
		
		public static const CHAR_ICONS:String = "assets/icons/";
		
		/** path relative to game of enemy jsons */
		public static const PATH:String = "assets/data/characters/";
		
		/** filename of file containing enemy json names */
		public static const BASE:String = "characters";
		
		/** filename of file containing teams */
		public static const TEAMS_BASE:String = "teams";
		
		/** extension of all data files */
		public static const EXTENSION:String = ".json";
		
		/** dictionary of name -> CharacterData */
		public var characters:Dictionary = new Dictionary();
		
		/** array -> array (team) -> strings (characters within team) */
		public var teams:Array = new Array();
		
		/** cache of team id -> array of CharacterData */
		public var teamData:Dictionary = new Dictionary();
		
		public function CharacterDatabase() {
			loadData();
		}
		
		/**
		 * Load base data file to get references to detailed data
		 */
		public function loadData():void {
			Database.loadData(PATH + BASE + EXTENSION, completeLoad);
			Database.loadData(PATH + TEAMS_BASE + EXTENSION, completeTeamsLoad);
		}
		
		function completeTeamsLoad(e:Event):void {
			var dat = JSON_.decode(e.target.data);
			
			teams = new Array();
			for (var i:String in dat.teams) {
				teams.push(dat.teams[i]);
			}
		}
		
		public function getUnlockedTeams():Array {
			return teams;
		}
		
		public function getAllCharacters():Array {
			var charData = new Array();
			for (var i = 0; i < teams.length; i++){
				for (var j:String in teams[i]) {
					charData.push(getCharacterData(teams[i][j]));
				}
			}
			
			return charData;
		}
		
		public function getTeamCharacterData(id:int):Array {
/*			trace(teamData.hasOwnProperty(0));
			trace(teamData.hasOwnProperty(1));
			trace(teamData.hasOwnProperty(2));*/
			if (!teamData.hasOwnProperty(id)) {
				var team:Array = new Array();
				
				for (var i:String in teams[id]) {
					team.push(getCharacterData(teams[id][i]));
				}
				
				teamData[id] = team;
			}
			
			return teamData[id];
		}
		
		/**
		 * Callback from loading base file with enemy names
		 */
		function completeLoad(e:Event):void {
			var dat = JSON_.decode(e.target.data);
			
			for (var charName:String in dat.characters) {
				Database.loadData(PATH + dat.characters[charName] + EXTENSION, completeLoadChar);
			}
		}
		
		function completeLoadChar(e:Event):void {
			var obj = JSON_.decode(e.target.data);
			
			var cdat:CharacterData = new CharacterData();
			cdat.parseData(obj);
			
			characters[cdat.id] = cdat;
		}
		
		public function getAllCharacterData():Dictionary {
			return characters;
		}
		
		public function getCharacterData(id:String):CharacterData {
			return characters[id];
		}
	}
}