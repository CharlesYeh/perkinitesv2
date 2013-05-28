package scripting.actions {
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import flash.filters.GlowFilter;
	
	import game.Game;
	import game.MapManager;
	import scripting.Sequence;
	
	
	public class ActionSkip extends Action{
		
		/** type of thing to delete */
		
		public var skip:Boolean;	//either skips or receives the signal
		//var glowBegin = new GlowFilter(0x333333, 100, 2, 2, 1, 5, true, false);
		
		override public function parseData(obj:Object):void {
			super.parseData(obj);
			
			skip = obj.skip;
		}
		
		override public function act():void {
			if(skip){
				//add a button
				var b = new SkipButton();
				b.gotoAndStop(1);
				b.addEventListener(Event.ENTER_FRAME, eventHandler);
				b.addEventListener(MouseEvent.CLICK, skipHandler);
				b.addEventListener(MouseEvent.MOUSE_OVER, entryOverHandler);
				b.addEventListener(MouseEvent.MOUSE_OUT, entryOutHandler);	
				b.mouseChildren = false;
				Game.overlay.parent.addChild(b);
				b.x = 500;
				b.y = 395;
			}
			else{
				for(var i = 0; i < Game.overlay.parent.numChildren; i++){
					var child = Game.overlay.parent.getChildAt(i);
					if(child is SkipButton){
						child.removeEventListener(Event.ENTER_FRAME, eventHandler);
						child.removeEventListener(MouseEvent.CLICK, skipHandler);
						child.addEventListener(MouseEvent.MOUSE_OVER, entryOverHandler);
						child.addEventListener(MouseEvent.MOUSE_OUT, entryOutHandler);									
						Game.overlay.parent.removeChild(child);	
						i--;
					}
				}
			}
			complete();
		}
		
		function eventHandler(e:Event):void{
			if(e.target.parent != null){
				e.target.parent.setChildIndex(e.target, e.target.parent.numChildren - 1);
			}
		}
		function skipHandler(e:Event):void{
			if(e.target.parent != null){
				e.target.parent.removeChild(e.target);
			}
			var frameSubset = new Array();
			var foundSequence = null;
			outer: for (var i:String in MapManager.world.mapData.sequences) {
				var seq:Sequence = MapManager.world.mapData.sequences[i];
				
				//find the containing sequence, ASSUME IT HAS A RECEIVING ACTIONSKIP
				
				for(var j:String in seq.actions){
					var frame:Array = seq.actions[j];
					
					for(var k:String in frame){
						var action:Action = frame[k];
						if(this == action){
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
						action = frame[k];
						if(action is ActionSkip && !(ActionSkip)(action).skip){
							receive = true;
							action.complete();
							break outer2;
						}
					}
					
					if(!receive){
						for(k in frame){
							action = frame[k];
							action.complete();
						}						
					}
				}
				e.target.removeEventListener(Event.ENTER_FRAME, eventHandler);
				e.target.removeEventListener(MouseEvent.CLICK, skipHandler);
			}
					
		}
		
		function entryOverHandler(e) {
			e.target.gotoAndStop(2);
		}
		function entryOutHandler(e) {
			e.target.gotoAndStop(1);
		}			
	}
}