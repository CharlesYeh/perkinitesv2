package scripting.actions {
	import db.dbData.DatabaseData;
	
	import flash.utils.getDefinitionByName;
	
	public class Action implements DatabaseData {
		/** compile classes */
		//public static const actionTypes:Array = new Array(ActionControls, ActionBlackout);
		
		public var subtype:String;
		
		/** length of action in frames */
		public var time:int;
		
		private var m_complete:Boolean;
		
		private function compileClasses():void {
			var actionTypes:Array = new Array(ActionControls, ActionBlackout);
		}
		
		public function parseData(obj:Object):void {
			subtype = obj.subtype;
			time = obj.time;
		}
		
		public function act():void {
			m_complete = false;
			// do stuff
		}
		
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