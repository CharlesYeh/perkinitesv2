package ui {
	import flash.display.MovieClip;
	import flash.display.Loader;
	
	import game.GameConstants;
	import scripting.actions.Action;
	
	public class Speech extends MovieClip {

		private var m_currSprite:Loader;
		
		public function Speech() {
			visible = false;
			
			x = (GameConstants.WIDTH - width)/2;
			y = GameConstants.HEIGHT - height - 10;
		}
		
		public function showText(act:Action, sprite:Loader, name:String, message:String):void {
			visible = true;
			//act.complete();
			
			if (m_currSprite != null) {
				removeChild(m_currSprite);
			}
			
			m_currSprite = sprite;
			m_currSprite.x = 18;
			m_currSprite.y = 18;
			addChild(sprite);
			
			txtName.text = name;
			txtMessage.text = message;
		}
		public function hideText(act:Action){
			visible = false;
			
			act.complete();
		}
	}
	
}
