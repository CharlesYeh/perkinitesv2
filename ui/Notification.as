package ui {
	import flash.display.MovieClip;
	import flash.display.Loader;
	
	import flash.events.Event;
	import units.Perkinite;
	
	public class Notification extends MovieClip {
		
		var perkinite:Perkinite;
		var duration:int;
		var maxDuration:int;
		
		private static var NOTIFICATION_SPACING:int = 60;
		public function Notification(u:Perkinite, d:int) {
			perkinite = u;
			duration = d;
			maxDuration = d;
			addEventListener(Event.ENTER_FRAME, eventHandler);
			alpha = 0;
		}
		
		public function eventHandler(e:Event):void{
			if(e.target.parent != null){
				e.target.parent.setChildIndex(e.target, e.target.parent.numChildren - 1);
			}
			
			e.target.x = perkinite.x;
			e.target.y = perkinite.y - NOTIFICATION_SPACING - note.textHeight;
			
			duration--;
			
			if(duration >= 9/10 * maxDuration){
				alpha = (maxDuration - duration)/((1/10) * maxDuration);
			}
			if(duration <= 1/5 * maxDuration){
				alpha = duration/((1/5) * maxDuration);
			}
			if(duration <= 0) {
				if(e.target.parent != null){
					e.target.parent.removeChild(e.target);					
				}
				removeEventListener(Event.ENTER_FRAME, eventHandler);
			}
		}
		
	}
	
}
