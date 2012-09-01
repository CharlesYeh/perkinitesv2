package scripting.actions {
	import db.dbData.DatabaseData;
	
	import flash.utils.getDefinitionByName;
	
	public class Action implements DatabaseData {
		public var subtype:String;
		
		/** length of action in frames */
		public var time:int;
		
		private var m_complete:Boolean;
		
		private function compileClasses():void {
			var actionTypes:Array = new Array(ActionControls, ActionBlackout, ActionSpeech, ActionWait, ActionNarrator, ActionMusic, ActionAI);
		}
		
		public function parseData(obj:Object):void {
			subtype = obj.subtype;
			time = obj.time;
		}
		
		/**
		 * start the action
		 */
		public function act():void {
			m_complete = false;
		}
		
		/**
		 * mark as finished
		 */
		public function complete():void {
			m_complete = true;
		}
		
		/**
		 * updates the action, returning true if completed
		 */
		public function update():Boolean {
			return m_complete;
		}
		
		public static function createAction(type:String):Action {
			var ActionClass:Class = getDefinitionByName("scripting.actions." + type) as Class;
			
			var act:Action = new ActionClass();
			return act;
		}
	}
}