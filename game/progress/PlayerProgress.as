package game.progress {
	import game.Game;
	
	import tileMapper.TileMap;
	
	import units.StatUnit;
	
	import flash.net.SharedObject;
	import flash.net.registerClassAlias;
	import flash.utils.Dictionary;
	
	public class PlayerProgress {
		
		private var sharedObj:SharedObject;
		
		public var id:String;
		
		public var flexPoints:int;
		
		/** array of all the sequences the player has already completed */
		public var completedSequences:Array = new Array();
		
		/** array of all the sequences the player has already cleared */
		public var clearedAreas:Array = new Array();
		
		/** dictionary of "item name" -> "boolean" */
		public var items:Dictionary = new Dictionary();
		
		/** character level ups achieved */
		public var levelUps:int;
		
		/** chosen team */
		public var chosenTeam:Array;
		
		/** set of the unlocked teams */
		public var unlockedTeams:Dictionary = new Dictionary();
		
		/** map position of the player */
		public var map:String;
		public var x:int;
		public var y:int;
		
		public function PlayerProgress() {
			registerClassAlias("pp", PlayerProgress);
			registerClassAlias("a", Array);
			registerClassAlias("d", Dictionary);
			
			sharedObj = SharedObject.getLocal("PERKINITES");
		}
		
		public function addCompletedSequence(id:String):void {
			completedSequences.push(id);
			
			//----------------AUTO-SAVE----------------
			save();
		}
		
		public function hasCompletedSequence(id:String):Boolean {
			return completedSequences.indexOf(id) != -1;
		}
		
		public function unlockItem(item:String):void {
			items[item] = true;
		}
		
		public function hasUnlockedItem(item:String):Boolean {
			return items.hasOwnProperty(item);
		}
		
		public function addClearedArea(id:String):void {
			clearedAreas.push(id);
		}
		public function hasClearedArea(id:String):Boolean {
			return clearedAreas.indexOf(id) != -1;
		}		
		
		public function unlockTeam(team:Array):void {
			unlockedTeams[team.join("_")] = true;
		}
		
		public function hasUnlockedTeam(team:Array):Boolean {
			return unlockedTeams.hasOwnProperty(team.join("_"));
		}
		
		public function newGame():void {
			id = "PERKINITES";
			flexPoints = 0;
			
			map = "perkins_2f";
			x = 5;
			y = 10;
			
			completedSequences = new Array();
			items = new Dictionary();
			
			unlockedTeams = new Dictionary();
			unlockedTeams["CY_NM"] = true;
			unlockedTeams["JT_EH"] = true;
			unlockedTeams["HQ_HV"] = true;
			unlockedTeams["CK_CM"] = true;			
		}
		
		public function loadGame(soId:String):void {
			var prog:Object = sharedObj.data[soId];
			
			x = prog.x;
			y = prog.y;
			
			id		= soId;
			flexPoints = prog.flexPoints;
			
			map		= prog.map;
			completedSequences = prog.completedSequences;
			clearedAreas = prog.clearedAreas;
			items	= prog.items;
			
			unlockedTeams = prog.unlockedTeams;
		}
		
		public function save():void {
			var so:SharedObject = sharedObj;
			sharedObj = null;
			
			var player:StatUnit = Game.team[0];
			x = player.x / TileMap.TILE_SIZE;
			y = player.y / TileMap.TILE_SIZE;
			
/*			var uteams = unlockedTeams;
			unlockedTeams = uteams();*/
			
			// save this object without reference to SharedObject
			so.data[id] = this;
			so.flush();
			
			// restore variables
			sharedObj = so;
			//unlockedTeams = uteams;
		}
	}
	
}
