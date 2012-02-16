package game {
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.display.MovieClip;
	import flash.geom.Point;

	public class Perkinite extends GameUnit {
		
		static const DIRECTIONS:Array = new Array("east", "north", "west", "south");

		static const ANIM_STANDING	= "standing";
		static const ANIM_FF		= "friend_finale";
		static const ANIM_WALKING	= "walking";
		static const ANIM_ABILITY1	= "ability1";
		static const ANIM_ABILITY2	= "ability2";
		static const ANIM_ABILITY3	= "ability3";
		
		var swf;
		
		var animLabel:String;
		var animClip:MovieClip;
		var loaded = false;
		
		//----------STATS VARS---------
		var ID:int;
		var healthMax:Number;
		var healthPoints:Number;
		//--------END STATS VARS-------
		
		//---------ABILITY VARS---------
		var castAbilityID:int;
		var castMousePoint:Point;
		//-------END ABILITY VARS-------
		
		//----------FRAME VARS----------
		var prevLabel:String;
		var usingAbility:Boolean	= false;
		var disabledMovement:Boolean= false;
		var forwardMovement:Boolean = false;
		
		//--------END FRAME VARS--------
		
		public function Perkinite() {
			// constructor code
			super();
			
			animLabel = ANIM_WALKING;
			
			// load swf
			loadSwf();
		}
		protected function loadSwf() {
			swf = new Loader();
			swf.load(getSprite());
			addChild(swf);
			
			swf.contentLoaderInfo.addEventListener(Event.COMPLETE, completeLoad);
		}
		protected function getSprite() {
			return new URLRequest(CharacterDatabase.getSprite(id));
		}
		function completeLoad(e) {
			loaded = true;
			
			swf.content.char.stop();
			swf.content.char.dire.gotoAndStop(ANIM_WALKING);
			swf.content.char.dirn.gotoAndStop(ANIM_WALKING);
			swf.content.char.dirs.gotoAndStop(ANIM_WALKING);
			setAnimLabel(ANIM_WALKING);
			updateDirection(0);
			
			swf.content.char.endAbility			= endAbility;
			swf.content.char.disableMovement	= disableMovement;
			swf.content.char.enableMovement		= enableMovement;
			swf.content.char.beginForwardMovement	= beginForwardMovement;
			swf.content.char.stopForwardMovement	= stopForwardMovement;
			swf.content.char.dealDamage			= dealDamage;
			swf.content.char.applyBuffs			= applyBuffs;
			swf.content.char.shootSkillshot		= shootSkillshot;
			swf.content.char.teleport			= teleport;
		}
		
		//--------------FRAME FUNCTIONS--------------
		public function endAbility() {
			usingAbility = false;
			setAnimLabel(prevLabel);
		}
		public function disableMovement() {
			disabledMovement = true;
		}
		public function enableMovement() {
			disabledMovement = false;
		}
		public function beginForwardMovement() {
			forwardMovement = true;
		}
		public function stopForwardMovement() {
			forwardMovement = false;
		}
		public function dealDamage() {
			
		}
		public function applyBuffs() {
			
		}
		public function shootSkillshot() {
			
		}
		public function teleport() {
			
		}
		//------------END FRAME FUNCTIONS------------
		public function setTarget(unit:GameUnit) {
			startCastAnimation(castAbilityID);
		}
		public function castAbility(abID:int, mousePos:Point) {
			if (usingAbility)
				return;
			
			switch (AbilityDatabase.getTargetType(ID, abID)) {
			case AbilityDatabase.ATKTYPE_TARGET:
				// wait for click on target
				//castAbilityID = abID;
				startCastAnimation(abID);
				break;
			case AbilityDatabase.ATKTYPE_POINT:
			case AbilityDatabase.ATKTYPE_AOE:
			case AbilityDatabase.ATKTYPE_SSHOT:
				// attack right away
				castMousePoint = mousePos;
				startCastAnimation(abID);
				break;
			}
		}
		function startCastAnimation(abID:int) {
			usingAbility = true;
			prevLabel = animLabel;
			
			switch (abID) {
			case 0:
				setAnimLabel(ANIM_ABILITY1);
				break;
			case 1:
				setAnimLabel(ANIM_ABILITY2);
				break;
			case 2:
				setAnimLabel(ANIM_ABILITY3);
				break;
			}
		}
		
		/**
		 * 
		 * the movement handler
		 * @parame - Event.ENTER_FRAME
		 */
		override public function moveHandler(e:Event):void {
			if (disabledMovement)
				return;
			
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
		override public function turnLeft() {
			super.turnLeft();
			updateDirection(moveDir);
		}
		override public function turnRight() {
			super.turnRight();
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
	}
}
