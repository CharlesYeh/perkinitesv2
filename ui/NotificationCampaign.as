package ui {
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	
	import units.Perkinite;
	
	public class NotificationCampaign extends Notification {
		
		public function NotificationCampaign(d:int) {
			super(d);
		}
		
		override public function eventHandler(e:Event):void{
			if(e.target.parent != null){
				e.target.parent.setChildIndex(e.target, e.target.parent.numChildren - 1);
			}
			
			e.target.x = 0;
			e.target.y = 0;
			
			duration--;
			
			if(duration >= 9/10 * maxDuration){
				e.target.gotoAndStop(1);
				alpha = (maxDuration - duration)/((1/10) * maxDuration);
			}
			if(duration <= 1/5 * maxDuration){
				e.target.gotoAndStop(2);
			}
			if(duration <= 0) {
				alpha = 0;
				if(e.target.parent != null){
					e.target.parent.removeChild(e.target);					
				}
				removeEventListener(Event.ENTER_FRAME, eventHandler);
			}
		}
		
	}
	
}
