package ui {
	import flash.display.MovieClip;
	
	public class Journal extends MovieClip {
		
		public var goal:String;	//what will be displayed on the screen
		var goalWait:int;	//how long it takes to update
		var maxGoalWait:int;
		public function Journal() {
			goal = "";
			goalWait = 0;
			maxGoalWait = 2;
			goalDisplay.text = "";
		}
		
		public function setGoal(message:String){
			goal = message;
		}
		
		public function updateGoal(){
			goalWait--;
			if(goalDisplay.text.length < goal.length && goalWait <= 0){
				//SoundManager.playSound("");
				goalWait = maxGoalWait;
				goalDisplay.text = goal.substring(0, goalDisplay.text.length + 1);
			}
			
		}
	}
}
