package scripting.actions {
	
	import game.Game;
	import ui.Notification;
	
	public class ActionNotification extends Action {
		
		public var message:String;
		
		override public function parseData(obj:Object):void {
			super.parseData(obj);
			
			message = obj.message;
		}
		
		override public function update():Boolean {
			return super.update();
		}
		
		override public function act():void {
			//add notification to the top of the player unit
			//set its time to the time of this action
			var m_time = time;	//why was this -1 if I didn't have m_time?
			var n = new Notification(Game.team[0], m_time);
			n.note.text = message;
			Game.team[0].parent.addChild(n);
			complete();
		}
	}
}