package scripting.actions {
	import db.dbData.DatabaseData;
	
	public class Action implements DatabaseData {
		public var subtype:String;
		
		/** length of action in frames */
		public var time:int;
		
		private var m_complete:Boolean;
		
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
		
		public function isComplete():Boolean {
			return m_complete;
		}
		
		/**
		 * updates the action, returning true if completed
		 */
		public function update():Boolean {
			return m_complete;
		}
	}
}