package scripting.actions {
	import db.ImageDatabase;
	import game.Game;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	
	import flash.filters.GlowFilter;
	
	public class ActionSpeech extends Action{
		
		/** path relative to game of enemy jsons */
		public static const PATH:String = "assets/data/sequences/";
		
		/** filename of file containing enemy json names */
		public static const BASE:String = "sequences";
		
		/** path relative to game of enemy jsons */
		public static const EXTENSION:String = ".json";
		
		public var icon:Loader;
		
		public var name:String = "";
		
		public var message:String = "";
		
		
		override public function parseData(obj:Object):void {
			super.parseData(obj);
			
			// TODO: get sprite from image cache
			icon = ImageDatabase.getIcon(obj.icon);				
			name = (obj.name != null) ? obj.name : "";
			message = (obj.message != null) ? obj.message : "";
		}
		
		override public function update():Boolean {	
			return super.update();
		}
		
		override public function act():void {
			//add a button
			var b = new SkipButton();
			b.buttonText.text = "Next";
			b.gotoAndStop(1);
			b.addEventListener(MouseEvent.CLICK, nextHandler);
			b.addEventListener(MouseEvent.MOUSE_OVER, entryOverHandler);
			b.addEventListener(MouseEvent.MOUSE_OUT, entryOutHandler);	
			b.mouseChildren = false;
			Game.overlay.parent.addChild(b);
			b.x = 515;
			b.y = 375;
			
			
			if(key == "npc") {
				var npc = Game.world.getActivatedNPC().mapCharacterData;
				icon = ImageDatabase.getIcon("Face Icon - " + npc.id + ".png");
				name = Game.dbSpch.getName(npc.id);
				message = Game.dbSpch.getSpeech(npc.id, "perkinite_" + npc.id);
				if(message == null) {
					var type = "npc";
					if(Game.team[0].unitData.id == npc.id) {
						type = "mirror";
					}			
					message = Game.dbSpch.getSpeech(npc.id, type);
				}
			}
			
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
			e.target.gotoAndStop(2);
			e.target.buttonText.text = "Next";
		}
		function entryOutHandler(e) {
			e.target.gotoAndStop(1);
			e.target.buttonText.text = "Next";
		}					
	}
}