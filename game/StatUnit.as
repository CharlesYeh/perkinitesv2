﻿package game {
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.display.MovieClip;
	import flash.geom.Point;
	
	import db.AbilityDatabase;

	public class StatUnit extends GameUnit {
		
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
		var healthbar:MovieClip;
		//--------END STATS VARS-------
		
		//---------ABILITY VARS---------
		var castAbilityID:int;
		var castAbilityType:String;
		var castMousePoint:Point;
		var castMouseTarget:StatUnit;
		//-------END ABILITY VARS-------
		
		//----------FRAME VARS----------
		var prevLabel:String;
		var usingAbility:Boolean	= false;
		var disabledMovement:Boolean= false;
		var forwardMovement:Boolean = false;
		
		var guide:MovieClip;
		//--------END FRAME VARS--------
		
		public function StatUnit() {
			// constructor code
			super();
			
			animLabel = ANIM_WALKING;
			ID = 0;
			
			// THESE SHOULD BE OVERRIDEN IN SUBCLASSES
			healthPoints = healthMax = 100;
			
			// draw health bar
			healthbar = new MovieClip();
			addChild(healthbar);
			drawHealthbar();
			
			// attach aim guides
			guide = new AimGuide();
			addChild(guide);
			guide.visible = false;
			
			castAbilityID = -1;
			castMouseTarget = null;
		}
		function drawHealthbar() {
			var WIDTH = 50;
			var sx = -WIDTH/2;
			
			healthbar.graphics.clear();
			healthbar.graphics.lineStyle(1, 0);
			healthbar.graphics.drawRect(sx, 30, WIDTH, 5);
			
			healthbar.graphics.beginFill(0x33FF33, .7);
			healthbar.graphics.drawRect(sx, 30, WIDTH * healthPoints / healthMax, 5);
			healthbar.graphics.endFill();
		}
		function takeDamage(dmg:Number) {
			healthPoints = Math.max(0, healthPoints - dmg);
			drawHealthbar();
		}
		protected function loadSwf() {
			swf = new Loader();
			swf.load(getSprite());
			addChild(swf);
			
			swf.contentLoaderInfo.addEventListener(Event.COMPLETE, completeLoad);
		}
		protected function getSprite() {
			//return new URLRequest(CharacterDatabase.getSprite(ID));
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
			castMouseTarget.takeDamage(5);
		}
		public function applyBuffs() {
			
		}
		public function shootSkillshot(array:Array) {
			
		}
		public function teleport() {
			x = castMousePoint.x;
			y = castMousePoint.y;
			
			teleportTo(x, y);
			clearPath();
		}
		//------------END FRAME FUNCTIONS------------
		public function castAbility(abID:int, mousePos:Point) {
			if (usingAbility)
				return;
			
			castAbilityID = abID;
			castAbilityType = AbilityDatabase.getTargetType(ID, abID);
			
			switch (castAbilityType) {
			case AbilityDatabase.ATKTYPE_TARGET:
				// wait for click on target
				break;
			case AbilityDatabase.ATKTYPE_POINT:
			case AbilityDatabase.ATKTYPE_SSHOT:
				// wait for click
				break;
			case AbilityDatabase.ATKTYPE_SCAST:
				startCastAnimation();
				break;
			}
		}
		public function clickHandler(pos:Point, target:StatUnit) {
			castMousePoint	= pos;
			castMouseTarget	= target;
			
			startCastAnimation();
		}
		public function mouseHandler(pos:Point) {
			if (castAbilityID == -1) {
				guide.visible = false;
			}
			else {
				var horizmult:int = (scaleX > 0) ? 1 : -1;
				guide.visible = true;
				
				switch (castAbilityType) {
					case AbilityDatabase.ATKTYPE_POINT:
						guide.gotoAndStop("point");
						guide.guide_target.x = horizmult * (pos.x - x);
						guide.guide_target.y = pos.y - y;
						break;
					case AbilityDatabase.ATKTYPE_TARGET:
						guide.gotoAndStop("target");
						guide.guide_target.x = horizmult * (pos.x - x);
						guide.guide_target.y = pos.y - y;
						break;
					case AbilityDatabase.ATKTYPE_SSHOT:
						guide.gotoAndStop("skillshot");
						guide.guide_skillshot.rotation = Math.atan2(y - pos.y, horizmult * (x - pos.x)) * 180 / Math.PI + 180;
						break;
				}
			}
		}
		function startCastAnimation() {
			if (castAbilityID == -1 || castAbilityType == AbilityDatabase.ATKTYPE_TARGET && castMouseTarget == null)
				return;
			
			usingAbility = true;
			prevLabel = animLabel;
			
			switch (castAbilityID) {
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
			
			castAbilityID = -1;
		}
		
		/**
		 * 
		 * the movement handler
		 * @param e - Event.ENTER_FRAME
		 */
		override public function moveHandler(e:Event):void {
			if (forwardMovement) {
				// move forward!!
				// TODO: USE ABILITY MOVEMENT SPEED
				var mspeed = 30;
				
				var dx = castMousePoint.x - x;
				var dy = castMousePoint.y - y;
				trace(dx, dy);
				var d = Math.sqrt(dx * dx + dy * dy) / mspeed;
				dx = dx / d;
				dy = dy / d;
				teleportTo(x + dx, y + dy);
			}
			if (disabledMovement)
				return;
			
			super.moveHandler(e);
			
			// set frame?
			if (usingAbility)
				return
			
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
				healthbar.scaleX = -1;
			}
			else {
				frame = DIRECTIONS[dir];
				scaleX = 1;
				healthbar.scaleX = 1;
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
