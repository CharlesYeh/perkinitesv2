package ui {
	import flash.display.MovieClip;
	import flash.display.Loader;
	
	public class DecisionDisplay extends MovieClip {

		public var decisions:Array;
		public function DecisionDisplay() {
			visible = false;
			decisions = new Array(choice1, choice2, choice3, choice4);
			for(var i = 0; i < decisions.length; i++){
				var d = decisions[i];
				d.chosenIndex = i;
				d.mouseChildren = false;
			}
		}
	}
	
}
