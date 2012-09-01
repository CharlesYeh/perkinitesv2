package scripting {
	import db.dbData.DatabaseData;
	import scripting.actions.*;
	import scripting.conditions.*;
	import game.Game;
	
	public class Sequence implements DatabaseData {
		
		public var id:String;
		public var actions:Array;
		
		/** current action index within "actions" */
		private var m_index:int;
		
		private var m_completed:Boolean;
		
		private function compileClasses():void {
			var actionTypes:Array = new Array(ActionControls, ActionBlackout, ActionSpeech, ActionWait, ActionNarrator, ActionMusic, ActionAI);
			var condTypes:Array = new Array(ConditionSequence);
		}
		
		public function parseData(obj:Object):void {
			id = obj.id;
			
			actions = new Array();
			for (var i:String in obj.actions) {
				var fdat:Array = obj.actions[i];
				var frame:Array = new Array();
				
				for (var j:String in fdat) {
					var adat:Object = fdat[j];
					
					var a:Action = createAction(adat.type);
					a.parseData(adat);
					frame.push(a);
				}
				
				actions.push(frame);
			}
		}
		
		public static function createAction(type:String):Action {
			var ActionClass:Class = getDefinitionByName(type) as Class;
			
			var act:Action = new ActionClass();
			return act;
		}
		
		public function start():void {
			m_index = 0;
			m_completed = false;
			
			// test whether this sequence has been done before
			if (actions.length == 0 || Game.playerProgress.hasCompletedSequence(id)) {
				m_completed = true;
			}
			// start first frame
			if(!m_completed){
				startFrame();
			}
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
			
			var frame:Array = actions[m_index];
			
			var allCompleted:Boolean = true;
			for (var i:String in frame) {
				var act:Action = frame[i];
				
				// update all actions, and see if all are done
				allCompleted = act.update() && allCompleted;
			}
			
			if (allCompleted) {
				m_index++;
				
				if (m_index == actions.length) {
					complete();
				}
				else {
					startFrame();
				}
			}
		}
		
		public function complete():void {
			Game.playerProgress.addCompletedSequence(id);
			m_completed = true;
		}
	}
}