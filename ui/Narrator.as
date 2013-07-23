package ui {
	import flash.display.MovieClip;
	import flash.display.Loader;
	import flash.text.TextFormat;
	import flash.events.MouseEvent;
	
	import game.GameConstants;
	import game.MapManager;
	import scripting.Sequence;
	import scripting.actions.Action;
	import scripting.actions.ActionSkip;
	
	public class Narrator extends MovieClip {
		
		var bold;
		var toggle;
		var action;
		public function Narrator() {
			visible = false;
			toggle = true;
			action = null;
			y = GameConstants.HEIGHT - height;
			//y = 8;
			bold = new TextFormat("Corbel", 16, 0xFFFFFF, true, false);
			nextButton.gotoAndStop(1);
			skipButton.gotoAndStop(3);
		}
		
		public function setAction(action:Action): void {
			this.action = action;
		}
		public function setToggle(toggle:Boolean): void {
			this.toggle = toggle;
			trace(toggle);
		}	
		public function showText(text:String):void {
			visible = true;
			
			
			txtMessage.text = text;
			txtMessage.setTextFormat(bold);
			
			if (toggle) {
				nextButton.visible = true;
				skipButton.visible = true;
				nextButton.addEventListener(MouseEvent.MOUSE_OVER, nextOverHandler);
				nextButton.addEventListener(MouseEvent.MOUSE_OUT, nextOutHandler);
				nextButton.addEventListener(MouseEvent.CLICK, nextHandler);
				skipButton.addEventListener(MouseEvent.MOUSE_OVER, skipOverHandler);
				skipButton.addEventListener(MouseEvent.MOUSE_OUT, skipOutHandler);		
				skipButton.addEventListener(MouseEvent.CLICK, skipHandler);			
			}
			else{
				nextButton.visible = false;
				skipButton.visible = false;
			}
		}
		public function hideText(act:Action):void {
			visible = false;
			if (!toggle) {
				nextButton.removeEventListener(MouseEvent.MOUSE_OVER, nextOverHandler);
				nextButton.removeEventListener(MouseEvent.MOUSE_OUT, nextOutHandler);
				skipButton.removeEventListener(MouseEvent.MOUSE_OVER, skipOverHandler);
				skipButton.removeEventListener(MouseEvent.MOUSE_OUT, skipOutHandler);		
			}			
			nextButton.removeEventListener(MouseEvent.CLICK, nextHandler);	
			skipButton.removeEventListener(MouseEvent.CLICK, skipHandler);					
			act.complete();
		}
		function nextOverHandler(e) {
			e.target.gotoAndStop(2);
		}
		function nextOutHandler(e) {
			e.target.gotoAndStop(1);
		}		
		function skipOverHandler(e) {
			e.target.gotoAndStop(4);
		}
		function skipOutHandler(e) {
			e.target.gotoAndStop(3);
		}		
		function nextHandler(e) {
			hideText(action);
		}
		function skipHandler(e) {
			var frameSubset = new Array();
			var foundSequence = null;
			outer: for (var i:String in MapManager.world.mapData.sequences) {
				var seq:Sequence = MapManager.world.mapData.sequences[i];
				
				//find the containing sequence, ASSUME IT HAS A RECEIVING ACTIONSKIP
				
				for(var j:String in seq.actions){
					var frame:Array = seq.actions[j];
					
					for(var k:String in frame){
						var act:Action = frame[k];
						if(this.action == act){
							foundSequence = seq;
							break outer;
						}
					}
				}
			}
			if(foundSequence != null){
				var receive = false;				
				outer2: for(j in foundSequence.actions){
					frame = foundSequence.actions[j];
					
					for(k in frame){
						act = frame[k];
						if(act is ActionSkip && !(ActionSkip)(act).skip){
							receive = true;
							act.complete();
							break outer2;
						}
					}
					
					if(!receive){
						for(k in frame){
							act = frame[k];
							act.complete();
						}						
					}
				}
				
				hideText(this.action);
			}			
		}
	}
}
