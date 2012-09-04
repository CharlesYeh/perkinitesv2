package scripting.actions {
	import game.Game;
	import game.Controls;
	
	public class ActionUnlockCharacters extends Action{

		/** num of times to unlock */
		public var quantity:int;
		
		private var m_quantity:int;
		override public function parseData(obj:Object):void {
			super.parseData(obj);
			
			quantity = obj.quantity;
		}
		
		override public function update():Boolean{
			if(Game.overlay.charUnlock.done){
				Game.overlay.charUnlock.disable();
				m_quantity--;
				if(m_quantity <= 0){
					Controls.enabled = true;							
					complete();
				}
				else{
					Game.overlay.charUnlock.enable();					
				}
			}
			return super.update();
			
		}
		override public function act():void {
			super.act();
			
			m_quantity = quantity;
			Controls.enabled = false;			
			Game.overlay.charUnlock.enable();
		}
	}
}