package scripting.controls{
	
	import db.ImageDatabase;
	import game.Game;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import scripting.Sequence;
	import scripting.actions.ActionSpeech;
	
	
	import flash.filters.GlowFilter;
	
	public class ControlDecision extends ActionSpeech{
		
		public var decisions:Array;
		
		public var sequences:Array;
		
		public var chosenIndex:int = -1;
		
		override public function parseData(obj:Object):void {
			super.parseData(obj);
			
			decisions = new Array();
			sequences = new Array();
			
			var dec = obj.decisions;
			var seq = obj.sequences;
			
			if(dec.length != seq.length) {
				throw Error("Control Decision at : dec length != seq length");
			}
			
			for(var i = 0; i < dec.length; i++){
				decisions.push(dec[i]); //they should just be strings
			}
			
			for(var i = 0; i < seq.length; i++){
				var s = new Sequence();
				s.repeatable = true;
				s.saveable = false;
				s.parseData(seq[i]);
				sequences.push(s);
			}
		}
		
		override public function update():Boolean {	
			if(chosenIndex != -1) {
				sequences[chosenIndex].updateActions();
				if(sequences[chosenIndex].update()){
					chosenIndex = -1;
					complete();
				}
			}
			
			return super.update();
		}
		
		override public function act():void {
			reset();
			
			chosenIndex = -1;
			for(var i = 0; i < decisions.length; i++){
				var d = Game.overlay.decisionDisplay.decisions[i];
				d.choice.text = decisions[i];
				d.addEventListener(MouseEvent.CLICK, nextHandler);
			}
			Game.overlay.decisionDisplay.visible = true;
			
			makeSpeech();
/*			if(key != null) {
				var npc = Game.world.getActivatedNPC().mapCharacterData;
				icon = ImageDatabase.getIcon("Face Icon - " + npc.id + ".png");
				name = Game.dbSpch.getName(npc.id);
				message = Game.dbSpch.getSpeech(npc.id, "perkinite_" + Game.perkinite.unitData.id);
				if(key == "acceptance" || key == "rejection") {
					message = Game.dbSpch.getSpeech(npc.id, key);
				} else if(message == null) {
					var type = key;
					if(Game.perkinite.unitData.id == npc.id && key == "greetings") {
						type = "mirror";
					}			
					message = Game.dbSpch.getSpeech(npc.id, type);
				}		
			} else if(playerIndex >= 0) {
				var npc = Game.team[playerIndex].unitData;
				icon = ImageDatabase.getIcon("Face Icon - " + npc.id + ".png");
				name = Game.dbSpch.getName(npc.id);
				message = Game.dbSpch.getSpeech(npc.id, "perkinite_" + Game.perkinite.unitData.id);
				if(message == null) {
					message = Game.dbSpch.getSpeech(npc.id, key);
				}
			}
			
			Game.overlay.speech.showText(this, icon, name, message);*/
		}
		
		function nextHandler(e:Event):void{
			Game.overlay.decisionDisplay.visible = false;
			Game.overlay.speech.hideText(this);
			reset(); //hideText accidentally completes this action - TODO fix
			
			for (var i = 0; i < decisions.length; i++){
				Game.overlay.decisionDisplay.decisions[i].choice.text = "--------";
				Game.overlay.decisionDisplay.decisions[i].removeEventListener(MouseEvent.CLICK, nextHandler);
				sequences[i].reset();
			}
			
			chosenIndex = e.target.chosenIndex;
			
			sequences[chosenIndex].start();
		}
		function entryOverHandler(e) {
			e.target.gotoAndStop(2);
		}
		function entryOutHandler(e) {
			e.target.gotoAndStop(1);
		}					
	}
}