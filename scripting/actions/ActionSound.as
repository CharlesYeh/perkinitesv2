package scripting.actions {
	
	import game.SoundManager;
	
	public class ActionSound extends Action {
		
		public var sound:String;
		
		override public function parseData(obj:Object):void {
			super.parseData(obj);
			
			sound = obj.sound;
		}
		
		override public function act():void {
			//SoundManager.playSound(sound);
			complete();
		}
	}
}