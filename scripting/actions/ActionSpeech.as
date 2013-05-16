package scripting.actions {
	import db.ImageDatabase;
	import game.Game;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	
	import flash.filters.GlowFilter;
	
	public class ActionSpeech extends Action{
		
		public var icon:Loader;
		
		public var name:String = "";
		
		public var message:String = "";
		
		var glowBegin = new GlowFilter(0xFF9900, 100, 20, 20, 1, 10, true, false);
		
		override public function parseData(obj:Object):void {
			super.parseData(obj);
			
			// TODO: get sprite from image cache
			icon = ImageDatabase.getIcon(obj.icon);
			name = obj.name;
			message = obj.message;
		}
		
		override public function update():Boolean {	
			return super.update();
		}
		
		override public function act():void {
			//add a button
			var b = new SelectButton();
			b.buttonText.text = "Next";
			b.addEventListener(MouseEvent.CLICK, nextHandler);
			b.addEventListener(MouseEvent.MOUSE_OVER, entryOverHandler);
			b.addEventListener(MouseEvent.MOUSE_OUT, entryOutHandler);	
			b.mouseChildren = false;
			Game.overlay.parent.addChild(b);
			b.x = 400;
			b.y = 400;
			
			Game.overlay.speech.showText(this, icon, name, message);
		}
		
		function nextHandler(e:Event):void{
			if(e.target.parent != null){
				e.target.parent.removeChild(e.target);
			}
			complete();
			Game.overlay.speech.hideText(this);
			e.target.removeEventListener(MouseEvent.CLICK, nextHandler);
		}
		
		function entryOverHandler(e) {
			e.target.filters = [glowBegin];
		}
		function entryOutHandler(e) {
			e.target.filters = [];
		}					
	}
}