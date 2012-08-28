package ui {
	import flash.display.MovieClip;
	import fl.transitions.Tween;
	import fl.transitions.TweenEvent;
	import flash.events.Event;
	
	import scripting.actions.Action;
	
	import game.GameConstants;
	
	import util.TextUtil;
	
	public class BlackScreen extends MovieClip {
		
		/** the action which triggered this animation */
		private var currAction:Action;
		
		/** the current tween that's happening */
		private var currTween:Tween;
		
		public function BlackScreen() {
			visible = false;
			txt.text = "";
		}
		
		public function editText(act:Action, val:String):void {
			act.complete();
			
			txt.text = val;
			TextUtil.vertAlign(txt, GameConstants.HEIGHT / 2);
		}
		
		public function show(act:Action, f:int):void {
			visible = true;
			currAction = act;
			
			currTween = new Tween(this, "alpha", null, 0, 1, f);
			currTween.addEventListener(TweenEvent.MOTION_FINISH, endShow);
		}
		
		public function hide(act:Action, f:int):void {
			visible = true;
			currAction = act;
			
			currTween = new Tween(this, "alpha", null, 1, 0, f);
			currTween.addEventListener(TweenEvent.MOTION_FINISH, endShow);
		}
		
		function endShow(e:Event) {
			currAction.complete();
			
			if (currTween != null) {
				currTween.removeEventListener(TweenEvent.MOTION_FINISH, endShow);
				currTween = null;
			}
		}
	}
}
