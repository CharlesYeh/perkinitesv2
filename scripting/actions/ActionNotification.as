package scripting.actions {
	import flash.events.Event;
	
	import game.Game;
	
	import ui.Notification;
	
	public class ActionNotification extends Action {
		
		public static var notification:Notification;
		public var title:String;
		public var longSubtitle:String;
		public var preSubtitle:String;
		public var subtitle:String;
		
		override public function parseData(obj:Object):void {
			super.parseData(obj);
			
			title = obj.title;
			longSubtitle = (obj.longSubtitle != null) ? obj.longSubtitle : "";
			preSubtitle = (obj.preSubtitle != null) ? obj.preSubtitle : "";
			subtitle = (obj.subtitle != null) ? obj.subtitle : "";
		}
		
		override public function update():Boolean {
			return super.update();
		}
		
		override public function act():void {
			
			if (notification != null && notification.parent != null) {
				notification.removeEventListener(Event.ENTER_FRAME, notification.eventHandler);
				Game.overlay.removeChild(notification);
			}
			
			if (notification != null) {
				notification = null;
			}
			
			//add notification to the top of the player unit
			//set its time to the time of this action
			var m_time = time;	//why was this -1 if I didn't have m_time?
			var n = new Notification( m_time);
			n.preSubtitle.text = "";
			n.subtitle.text = "";
			
			
			n.title.text = title;
			n.longSubtitle.text = longSubtitle;
			n.preSubtitle.text = preSubtitle;
			n.subtitle.text = subtitle;
			Game.overlay.addChild(n);
			
			notification = n;
			complete();
		}
	}
}