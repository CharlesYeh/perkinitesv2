package game.progress {
	import flash.net.SharedObject;
	import flash.utils.Dictionary;
	
	public class PlayerProgress {
		
		private var sharedObj:SharedObject;
		
		public var id:String;
		
		/** array of all the sequences the player has already completed */
		public var completedSequences:Array = new Array();
		
		/** dictionary of "item name" -> "item quantity owned" */
		public var items:Dictionary = new Dictionary();
		
		public var unlockedTeams:Dictionary = new Dictionary();
		
		public var map:String;
		public var x:int;
		public var y:int;
		
		public function PlayerProgress() {
			sharedObj = SharedObject.getLocal("PERKINITES");
		}
		
		public function addCompletedSequence(id:String):void {
			completedSequences.push(id);
		}
		
		public function hasCompletedSequence(id:String):Boolean {
			return completedSequences.indexOf(id) != -1;
		}
		
		public function unlockTeam(team:Array):void {
			unlockedTeams[team.join("_")] = true;
		}
		
		public function hasUnlockedTeam(team:Array):Boolean {
			return unlockedTeams.hasOwnProperty(team.join("_"));
		}
		
		public function reset():void {
			id = "";
			completedSequences = new Array();
			items = new Dictionary();
			
			unlockedTeams = new Dictionary();
			unlockedTeams["CY_NM"] = true;
			unlockedTeams["JT_EH"] = true;
		}
		
		public function load(soId:String):void {
			var prog:PlayerProgress = sharedObj.data[soId];
			
			id		= soId;
			completedSequences = prog.completedSequences;
			items	= prog.items;
			
			unlockedTeams = prog.unlockedTeams;
		}
		
		public function save():void {
			var so:SharedObject = sharedObj;
			sharedObj = null;
			
			// save this object without reference to SharedObject
			so.data[id] = this;
			so.flush();
			
			sharedObj = so;
		}
	}
	
}
