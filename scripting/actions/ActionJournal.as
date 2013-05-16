package scripting.actions {
	
	import game.Game;
	
	public class ActionJournal extends Action {
		
		public var message:String;
		public var completed:Boolean;
		
		override public function parseData(obj:Object):void {
			super.parseData(obj);
			
			message = obj.message;
			completed = obj.completed;
		}
		
		override public function update():Boolean {
			return super.update();
		}
		
		override public function act():void {
			if(completed){
				//play sound
				Game.overlay.journal.goalDisplay.textColor = 0x99CCFF;
				Game.overlay.journal.goalDisplay.text = Game.overlay.journal.goal + " - COMPLETE";
			}
			else{
				Game.overlay.journal.goalDisplay.textColor = 0xFFFFFF;
				Game.overlay.journal.setGoal(message);
				Game.overlay.journal.goalDisplay.text = "";
		
			}
			complete();

		}
	}
}