package ui {
	import flash.display.MovieClip;
	import flash.display.Loader;
	
	import game.GameConstants;
	import scripting.actions.Action;
	
	public class Speech extends MovieClip {

		private var m_currSprite:Loader;
		
		public function Speech() {
			visible = false;
			
			y = GameConstants.HEIGHT - height;
		}
		
		public function showText(act:Action, sprite:Loader, name:String, message:String):void {
			visible = true;
			act.complete();
			
			if (m_currSprite != null) {
				removeChild(m_currSprite);
			}
			
			m_currSprite = sprite;
			addChild(sprite);
			
			txtName.text = name;
			txtMessage.text = message;
		}
	}
	
}
