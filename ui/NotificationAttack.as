package ui {
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	
	import units.Perkinite;
	
	public class NotificationAttack extends Notification {
		
		public function NotificationAttack(d:int) {
			super(d);
		}
		
		override public function eventHandler(e:Event):void{
			if(e.target.parent != null){
				e.target.parent.setChildIndex(e.target, e.target.parent.numChildren - 1);
			}
			
			e.target.x = 0;
			e.target.y = 240 - e.target.height/2;
			
			duration--;
			
			if(duration >= 19/20 * maxDuration){
				alpha = (maxDuration - duration)/((1/20) * maxDuration);
			}
			if(duration <= 1/5 * maxDuration){
				alpha = duration/((1/5) * maxDuration);
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
