package scripting {
	import db.dbData.DatabaseData;
	import scripting.actions.*;
	import game.Game;
	
	public class Sequence implements DatabaseData {
		
		/** compile classes */
		public static const actionTypes:Array = new Array(ActionSpeech, ActionNarrator, ActionControls, ActionWait);
		
		public var id:String;
		public var actions:Array;
		
		/** current action index within "actions" */
		private var m_index:int;
		
		private var m_completed:Boolean;
		
		public function parseData(obj:Object):void {
			id = obj.id;
			
			actions = new Array();
			for (var i:String in obj.actions) {
				var fdat:Array = obj.actions[i];
				var frame:Array = new Array();
				
				for (var j:String in fdat) {
					var adat:Object = fdat[j];
					
					var a:Action = Action.createAction(adat.type);
					a.parseData(adat);
					frame.push(a);
				}
				
				actions.push(frame);
			}
		}
		
		public function start():void {
			m_index = 0;
			m_completed = true;
			
			// test whether this sequence has been done before
			if (actions.length == 0 || Game.playerProgress.hasCompletedSequence(id)) {
				m_completed = true;
			}
			
			// start first frame
			startFrame();
		}
		
		protected function startFrame():void {
			var frame:Array = actions[m_index];
			
			for (var i:String in frame) {
				var action:Action = frame[i];
				action.act();
			}
		}
		
		public function updateActions():void {
			if (m_completed) {
				return;
			}
			
			if (m_index == actions.length) {
				complete();
				return;
			}
			else {
				var frame:Array = actions[m_index];
				
				var allCompleted:Boolean = true;
				for (var i:String in frame) {
					var act:Action = frame[i];
					
					if (!act.isCompleted()) {
						allCompleted = false;
						break;
					}
				}
				
				if (allCompleted) {
					complete();
				}
			}
		}
		
		public function complete():void {
			Game.playerProgress.addCompletedSequence(id);
			m_completed = true;
		}
	}
}