package scripting.actions {
	import game.Game;
	
	public class ActionUnlockCharacters extends Action{

		override public function update():Boolean{
			if(Game.overlay.charUnlock.done){
				Game.overlay.charUnlock.disable();
				complete();
			}
			return super.update();
			
		}
		override public function act():void {
			super.act();
			
			Game.overlay.charUnlock.enable();
		}
	}
}