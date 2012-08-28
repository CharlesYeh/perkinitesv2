package scripting.actions {
	import db.dbData.DatabaseData;
	
	import flash.utils.getDefinitionByName;
	
	public class Action implements DatabaseData {
		/** compile classes */
		//public static const actionTypes:Array = new Array(ActionControls, ActionBlackout);
		
		/** length of action in frames */
		public var time:int;
		
		private var m_complete:Boolean;
		
		public function parseData(obj:Object):void {
			var actionTypes:Array = new Array(ActionControls, ActionBlackout);
			time = obj.time;
		}
		
		public function act():void {
			m_complete = false;
			// do stuff
		}
		
		public function complete():void {
			m_complete = true;
		}
		
		public function isCompleted():Boolean {
			return m_complete;
		}
		
		public static function createAction(type:String):Action {
			var ActionClass:Class = getDefinitionByName("scripting.actions." + type) as Class;
			
			var act:Action = new ActionClass();
			return act;
		}
	}
}