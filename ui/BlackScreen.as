package ui {
	import flash.display.MovieClip;
	import fl.transitions.Tween;
	import fl.transitions.TweenEvent;
	import scripting.actions.Action;
	
	public class BlackScreen extends MovieClip {
		
		private var currAction:Action;
		
		private var currTween:Tween;
		
		public function BlackScreen() {
			visible = false;
		}
		
		public function show(f:int, act:Action) {
			currAction = act;
			
			currTween = new Tween(this, "alpha", null, 0, 1, f);
			currTween.addEventListener(TweenEvent.MOTION_FINISH, endShow);
		}
		
		function endShow() {
			currAction.complete();
		}
	}
}
