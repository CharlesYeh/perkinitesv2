package game {
	import flash.net.SharedObject;
	import flash.utils.Dictionary;
	
	public class PlayerProgress {
		
		private var sharedObj:SharedObject;
		
		public var id:String;
		
		/** array of all the sequences the player has already completed */
		public var completedSequences:Array;
		
		/** dictionary of "item name" -> "item quantity owned" */
		public var items:Dictionary;
		
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
		
		public function reset():void {
			id = "";
			completedSequences = new Array();
			items = new Dictionary();
		}
		
		public function load(soId:String):void {
			var prog:PlayerProgress = sharedObj.data[soId];
			
			id		= soId;
			completedSequences = prog.completedSequences;
			items	= prog.items;
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
