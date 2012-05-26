package game {
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.display.MovieClip;
	import flash.geom.Point;
	
	import flashx.textLayout.operations.MoveChildrenOperation;
	
	import db.ActorDatabase;

	public class NPCUnit extends GameUnit {
		
		static const DIRECTIONS:Array = new Array("east", "north", "west", "south");

		static const ANIM_STANDING	= "standing";
		static const ANIM_FF		= "friend_finale";
		static const ANIM_WALKING	= "walking";
		static const ANIM_ABILITY1	= "ability1";
		static const ANIM_ABILITY2	= "ability2";
		static const ANIM_ABILITY3	= "ability3";
		
		var swf;
		var deleteFunc:Function = null;
		
		var animLabel:String;
		var animClip:MovieClip;
		var loaded = false;
		
		//----------MAP VARS---------
		public var sprite;
		public var xpos;
		public var ypos;
		//--------END MAP VARS-------
		
		//----------COMMAND VARS---------
		var current;
		//--------END COMMAND VARS-------
		
		//----------STATS VARS---------
		public var ID:int;
		//--------END STATS VARS-------
		
		//----------FRAME VARS----------
		var prevLabel:String;
		var usingAbility:Boolean	= false;
		var disabledMovement:Boolean= false;
		var forwardMovement:Boolean = false;
		var forwardVector:Point = null;

		//--------END FRAME VARS--------
		
		public function NPCUnit(spr) {
			// constructor code
			super();
			
			sprite = spr;
			animLabel = ANIM_STANDING;
			ID = 0;
			
			current = 0;
			
			loadSwf();
			
			//FIX THIS
			addEventListener(MouseEvent.CLICK, commandHandler);

		}
		protected function loadSwf() {
			swf = new Loader();
			swf.load(getSprite());
			addChild(swf);
			
			swf.contentLoaderInfo.addEventListener(Event.COMPLETE, completeLoad);
		}		
		protected function getSprite() {
			return new URLRequest(sprite);
		}
		function completeLoad(e) {
			loaded = true;
			
			swf.content.char.stop();
			swf.content.char.dire.gotoAndStop(ANIM_STANDING);
			swf.content.char.dirn.gotoAndStop(ANIM_STANDING);
			swf.content.char.dirs.gotoAndStop(ANIM_STANDING);
			setAnimLabel(ANIM_STANDING);
			updateDirection(moveDir);
		}	
		function setAnimLabel(l:String) {
			// standing, walking, friend_finale, ability1, ability2, ability3
			if (animClip == null || animLabel == l) return;
			
			animLabel = l;
			animClip.gotoAndStop(animLabel);
		}
		function updateDirection(dir:int) {
			if (!loaded) return;
			
			var frame;
			if (dir == 2) {
				frame = "east";
				scaleX = -1;
			}
			else {
				frame = DIRECTIONS[dir];
				scaleX = 1;
			}
			
			if (swf.content.char.currentLabel == frame) {
				// don't change labels
			}
			else {
				swf.content.char.gotoAndStop(frame);
				swf.content.char.dire.gotoAndStop(ANIM_WALKING);
				swf.content.char.dirn.gotoAndStop(ANIM_WALKING);
				swf.content.char.dirs.gotoAndStop(ANIM_WALKING);
				
				switch (dir) {
				case 0:
					animClip = swf.content.char.dire;
					break;
				case 1:
					animClip = swf.content.char.dirn;
					break;
				case 2:
					animClip = swf.content.char.dire;
					break;
				case 3:
					animClip = swf.content.char.dirs;
					break;
				}
				
				animClip.gotoAndStop(animLabel);
			}
		}
		function commandHandler(e:Event):void{
			for(var n in MapManager.npcUnits){
				var npc = MapManager.npcUnits[n];
				npc.removeEventListener(MouseEvent.CLICK, npc.commandHandler);
			}
			activateCommand();
		}
		
		function activateCommand(){
			if(current < commands.length){
				translateCommand(commands[current]);
			}
			else{
				current = 0;
				for(var n in MapManager.npcUnits){
					var npc = MapManager.npcUnits[n];
					npc.addEventListener(MouseEvent.CLICK, npc.commandHandler);
				}
			}
		}
		protected function translateCommand(xml:XML){
			if(xml.name()=="Message"){
				showMessage(xml);
			}
		}
		function showMessage(xml:XML){
			var m = new MessageBox();
			
			if(xml.FaceIcon == ""){
				m.messageDisplay.x = 12;
				m.messageDisplay.width = 566;
				m.nameDisplay.x = 12;
				
			}
			else{
				//fix this part
				var ic = ActorDatabase.getIcon(3);
			
				ic.x = 12.25;
				ic.y = 12.25;
				ic.width = 96;
				ic.height = 96;
				
				m.addChild(ic);
			}
			if(xml.Name == ""){
				m.messageDisplay.y = 12;
				m.messageDisplay.height = 106.05;			
			}
			m.nameDisplay.text = xml.Name;					
			
			m.messageDisplay.text = xml.Text;
			
			m.x = 34;
			m.y = 302;
			stage.addChild(m);
			m.mouseChildren = false;
			m.addEventListener(MouseEvent.CLICK, endMessageHandler);
			
		}
		
		function endMessageHandler(e):void{
			stage.removeChild(e.target);
			e.target.removeEventListener(MouseEvent.CLICK, endMessageHandler);
			current++;
			activateCommand();
		}
		
		//I'm a bit confused as how to incorporate the delete function more accurately.
		public function setDeleteFunction(func:Function) {
			deleteFunc = func;
		}
		protected function deleteSelf() {
			removeEventListener(Event.ENTER_FRAME, commandHandler);
		}
		//make it stop running when transferring to a new map
		public function destroy(){
			deleteSelf();
		}		
	}
}
