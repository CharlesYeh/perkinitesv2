package game {
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.display.MovieClip;
	import flash.geom.Point;
	
	import flashx.textLayout.operations.MoveChildrenOperation;
	
	import db.ActorDatabase;
	import db.NPCDatabase;
	import game.MapManager;
	import tileMapper.TileMap;

	public class NPCUnit extends StatUnit {
		
		public static var pauseActions:Boolean = false;		
		
		//----------MAP VARS---------
		public var sprite;
		public var xpos;
		public var ypos;
		public var initDir; //original direction of sprite when loaded onto map
		//--------END MAP VARS-------
		
		//----------COMMAND VARS---------
		var current; //current index of command they be on
		var forcedNPC; //sometimes cutscenes will force NPCs other than itself to move for it
		//--------END COMMAND VARS-------
		
		//----------FRAME VARS----------
		public var usingAnimation:Boolean	= false;
		public var frameCount:int = 0;

		//--------END FRAME VARS--------
		
		public function NPCUnit(spr) {
			// constructor code
			super();
			
			removeChild(healthbar);
			removeChild(guide);

			sprite = spr;
			
			current = 0;
			
			loadSwf();
			
			//FIX THIS
			addEventListener(MouseEvent.CLICK, commandHandler);

		}	
		override protected function getSprite() {
			return new URLRequest(sprite);
		}		
		override function completeLoad(e) {
			loaded = true;
			
			swf.content.char.stop();
			swf.content.char.dire.gotoAndStop(ANIM_STANDING);
			swf.content.char.dirn.gotoAndStop(ANIM_STANDING);
			swf.content.char.dirs.gotoAndStop(ANIM_STANDING);
			setAnimLabel(ANIM_STANDING);
			updateDirection(initDir);
		}	
		function commandHandler(e:Event):void{
			if(pauseActions)
				return;
				
			pauseActions = true;
			activateCommand();
		}
		
		function activateCommand(){
			if(current < commands.length)
				translateCommand(commands[current]);
			else{
				current = 0;
				pauseActions = false;
			}
		}
		protected function translateCommand(xml:XML){
			if(xml.name()=="Message")
				showMessage(xml);
			else if (xml.name()=="MoveDir")
				moveNPCDir(xml);
			else if (xml.name()=="MoveTo")
				moveNPCTo(xml);
			else if (xml.name()=="SpriteAnimation")
				showSpriteAnimation(xml);
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
				var ic = NPCDatabase.getFaceIcon(xml.FaceIcon);
			
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
		function moveNPCDir(xml:XML){
			if(xml.NPC == "this")
				forcedNPC = this;
			else
				forcedNPC = MapManager.npcUnits[int(xml.NPC)];
			
			if(xml.Dir == "0")
				forcedNPC.moveTo(forcedNPC.x+32, forcedNPC.y);
			else if (xml.Dir == "1")
				forcedNPC.moveTo(forcedNPC.x, forcedNPC.y-32);
			else if (xml.Dir == "2")
				forcedNPC.moveTo(forcedNPC.x-32, forcedNPC.y);
			else if (xml.Dir == "3")
				forcedNPC.moveTo(forcedNPC.x, forcedNPC.y+32);

			addEventListener(Event.ENTER_FRAME, endMovementHandler);			
		}
		function moveNPCTo(xml:XML){
			if(xml.NPC == "this")
				forcedNPC = this;
			else
				forcedNPC = MapManager.npcUnits[int(xml.NPC)];
				
			forcedNPC.moveTo((int(xml.xPos)+0.5)*TileMap.TILE_SIZE, (int(xml.yPos)+0.5)*TileMap.TILE_SIZE);
			addEventListener(Event.ENTER_FRAME, endMovementHandler);					
		}		
		function showSpriteAnimation(xml:XML){
			if(xml.NPC == "this")
				forcedNPC = this;
			else
				forcedNPC = MapManager.npcUnits[int(xml.NPC)];
			
			if(xml.NextAnimLabel == "previous")
				prevLabel = animLabel; //fix for forcedNPC
			else
				prevLabel = xml.NextAnimLabel; //fix for forcedNPC...
			
			forcedNPC.usingAnimation = true;
			forcedNPC.setAnimLabel(xml.AnimLabel);
			var aClip = forcedNPC.getAnimClip();
			for(var i in aClip.currentLabels){
				var l = aClip.currentLabels[i];
				if(l.name == xml.AnimLabel){
					if(i+1 >= aClip.currentLabels.length)
						forcedNPC.frameCount = aClip.totalFrames - aClip.currentLabels[i].frame;
					else
						forcedNPC.frameCount = aClip.currentLabels[i+1].frame - aClip.currentLabels[i].frame;
						
					break;
				}
			}
			addEventListener(Event.ENTER_FRAME, endSpriteAnimationHandler);
		}
		function endMessageHandler(e):void{
			stage.removeChild(e.target);
			e.target.removeEventListener(MouseEvent.CLICK, endMessageHandler);
			current++;
			activateCommand();
		}
		function endMovementHandler(e):void{
			if (forcedNPC.path.length == 0) {			
				forcedNPC = null;
				removeEventListener(Event.ENTER_FRAME, endMovementHandler);			
				current++;
				activateCommand();
			}
		}
		function endSpriteAnimationHandler(e):void{
			if(forcedNPC.frameCount == 0){
				forcedNPC.usingAnimation = false;
				forcedNPC.setAnimLabel(prevLabel);
				forcedNPC = null;				
				removeEventListener(Event.ENTER_FRAME, endSpriteAnimationHandler);
				current++;
				activateCommand();	
			}
			else{
				forcedNPC.frameCount--;
			}
		}
		override public function moveHandler(e:Event):void {
			if (usingAnimation)
				return
				
			super.moveHandler(e);			
			if (path.length == 0) {
				// not moving
				setAnimLabel(ANIM_STANDING);
			}
			else {
				updateDirection(moveDir);
				setAnimLabel(ANIM_WALKING);
			}
		}		
		public function getAnimClip():MovieClip{
			return animClip;
		}
	}
}
