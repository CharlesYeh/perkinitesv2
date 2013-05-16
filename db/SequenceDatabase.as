package db {
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	import scripting.Sequence;
	
	import com.adobe.serialization.json.*;

	public class SequenceDatabase implements DatabaseLoader {
		
		/** path relative to game of enemy jsons */
		public static const PATH:String = "assets/data/sequences/";
		
		/** filename of file containing enemy json names */
		public static const BASE:String = "sequences";
		
		/** path relative to game of enemy jsons */
		public static const EXTENSION:String = ".json";
		
		public var sequences:Dictionary = new Dictionary();
		
		public function SequenceDatabase() {
			loadData();
		}
		
		/**
		 * Load base data file to get references to detailed data
		 */
		public function loadData():void {
			Database.loadData(PATH + BASE + EXTENSION, completeLoad);
		}
		
		/**
		 * Callback from loading base file with enemy names
		 */
		function completeLoad(e:Event):void {			
			var dat = JSON_.decode(e.target.data);
			
			for (var sequenceId:String in dat.sequences) {
				Database.loadData(PATH + dat.sequences[sequenceId] + EXTENSION, completeLoadSequence);
			}
		}
		
		function completeLoadSequence(e:Event):void {
			var obj = JSON_.decode(e.target.data);
			
			var cdat:Sequence = new Sequence();
			cdat.parseData(obj);
			
			sequences[cdat.id] = cdat;
		}
		
		/**
		 * Returns the AttackData instance for this ability
		 */
		public function getSequence(sequenceId:String):Sequence {
			if (!sequences.hasOwnProperty(sequenceId)) {
				// error, should've loaded sequences first
			}
			
			return sequences[sequenceId];
		}
	}
}