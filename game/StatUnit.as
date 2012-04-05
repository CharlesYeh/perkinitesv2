﻿package game {
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.display.MovieClip;
	import flash.geom.Point;
	
	import tileMapper.TileMap;
	import db.AbilityDatabase;
	import flashx.textLayout.operations.MoveChildrenOperation;

	public class StatUnit extends GameUnit {
		
		static const DIRECTIONS:Array = new Array("east", "north", "west", "south");

		static const ANIM_STANDING	= "standing";
		static const ANIM_FF		= "friend_finale";
		static const ANIM_WALKING	= "walking";
		static const ANIM_ABILITY1	= "ability1";
		static const ANIM_ABILITY2	= "ability2";
		static const ANIM_ABILITY3	= "ability3";
		
		var swf;
		var partner:MovieClip;
		
		var animLabel:String;
		var animClip:MovieClip;
		var loaded = false;
		
		//----------STATS VARS---------
		public var ID:int;
		protected var healthMax:Number;
		protected var healthPoints:Number;
		var healthbar:MovieClip;
		//--------END STATS VARS-------
		
		//---------ABILITY VARS---------
		var castInputWait:Boolean;
		var castAbilityID:int;
		var castAbilityType:String;
		protected var castMousePoint:Point;
		protected var castMouseTarget:StatUnit;
		
		public var cooldowns:Array;
		//-------END ABILITY VARS-------
		
		//----------FRAME VARS----------
		var prevLabel:String;
		var usingAbility:Boolean	= false;
		var disabledMovement:Boolean= false;
		var forwardMovement:Boolean = false;
		var forwardVector:Point = null;
		
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
			castInputWait = false;
			castMouseTarget = null;
			cooldowns = new Array(10);
		}
		public function setPartner(p:StatUnit):void {
			// for partner teleport/friendly buffs
			partner = p;
		}
		protected function drawHealthbar() {
			var WIDTH = 50;
			var sx = -WIDTH/2;
			
			healthbar.graphics.clear();
			healthbar.graphics.lineStyle(1, 0);
			healthbar.graphics.drawRect(sx, 30, WIDTH, 5);
			
			healthbar.graphics.beginFill(0x33FF33, .7);
			healthbar.graphics.drawRect(sx, 30, WIDTH * healthPoints / healthMax, 5);
			healthbar.graphics.endFill();
		}
		public function getMaxCooldown(abid:int):Number {
			return AbilityDatabase.getAttribute(ID, abid, "Cooldown");
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
			swf.content.char.applyDebuffs       = applyDebuffs;
			swf.content.char.applyBuffs			= applyBuffs;
			swf.content.char.shootSkillshot		= shootSkillshot;
			swf.content.char.teleport			= teleport;
			swf.content.char.teleportPartner	= teleportPartner;
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
			
			// TODO: USE ABILITY MOVEMENT SPEED
			var mspeed = 30;
			
			var dx = castMousePoint.x - x;
			var dy = castMousePoint.y - y;
			var d = Math.sqrt(dx * dx + dy * dy) / mspeed;
			dx = dx / d;
			dy = dy / d;
			
			forwardVector = new Point(dx, dy);
		}
		public function stopForwardMovement() {
			forwardMovement = false;
			clearPath();
		}
		public function dealDamage(abilityID:int) {
			if (castMouseTarget == null)
				return;
			
			castMouseTarget.takeDamage(AbilityDatabase.getAttribute(ID, abilityID, "Damage"));
			
			// if point damage
			if (castAbilityType == AbilityDatabase.ATKTYPE_POINT) {
				
			}
		}
		public function applyDebuffs(abilityID:int) {
			
		}
		public function applyBuffs(abilityID:int) {
			
		}
		public function shootSkillshot(array:Array) {
			for(var i = 0; i < array.length; i++){
				this.parent.addChild(array[i]);
				if(moveDir == 2){
					array[i].x *= -1;
					array[i].rotation = 180;
				}
					array[i].x +=this.x;
					array[i].y +=this.y;
			}
		}
		public function teleport() {
			teleportTo(castMousePoint.x, castMousePoint.y);
			clearPath();
		}
		public function teleportPartner() {
			partner.teleportTo(castMousePoint.x, castMousePoint.y);
			partner.clearPath();
		}
		//------------END FRAME FUNCTIONS------------
		public function castAbility(abID:int, mousePos:Point) {
			if (usingAbility || cooldowns[abID] > 0)
				return;
			
			castAbilityID = abID;
			castAbilityType = AbilityDatabase.getTargetType(ID, abID);
			castInputWait = true;
			
			switch (castAbilityType) {
			case AbilityDatabase.ATKTYPE_TARGET:
				// wait for click on target
				break;
			case AbilityDatabase.ATKTYPE_POINT:
			case AbilityDatabase.ATKTYPE_SSHOT:
				// wait for click
				break;
			case AbilityDatabase.ATKTYPE_SCAST:
				castMousePoint = mousePos;
				startCastAnimation();
				break;
			}
		}
		public function clickHandler(pos:Point, target:StatUnit):Boolean {
			castMousePoint	= pos;
			castMouseTarget	= target;
			
			return startCastAnimation();
		}
		public function mouseHandler(pos:Point) {
			if (!castInputWait) {
				guide.visible = false;
			}
			else {
				var horizmult:int = (scaleX > 0) ? 1 : -1;
				guide.visible = true;
				
				// set range guide
				guide.range_circle.width = guide.range_circle.height =
							2 * AbilityDatabase.getAttribute(ID, castAbilityID, "Range");
				
				switch (castAbilityType) {
					case AbilityDatabase.ATKTYPE_POINT:
						guide.gotoAndStop("point");
						// set point radius
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
						// set skillshot width/length
						guide.guide_skillshot.rotation = Math.atan2(y - pos.y, horizmult * (x - pos.x)) * 180 / Math.PI + 180;
						break;
					case AbilityDatabase.ATKTYPE_CONE:
						guide.gotoAndStop("cone");
						// set cone width/length
						guide.guide_cone.rotation = Math.atan2(y - pos.y, horizmult * (x - pos.x)) * 180 / Math.PI + 180;
						break;
				}
			}
		}
		protected function startCastAnimation() {
			if (usingAbility || !castInputWait || 
				cooldowns[castAbilityID] > 0)
				return false;
			
			// test for range and target
			var dx = x - castMousePoint.x;
			var dy = y - castMousePoint.y;
			var dd = Math.sqrt(dx * dx + dy * dy);
			var range = AbilityDatabase.getAttribute(ID, castAbilityID, "Range");
			if (castAbilityType == AbilityDatabase.ATKTYPE_POINT &&
				dd > range)
				return false;
			
			if (castAbilityType == AbilityDatabase.ATKTYPE_TARGET &&
				(castMouseTarget == null || dd > range))
				return false;
			
			// look at direction of ability
			turnTo(castMousePoint);
			updateDirection(moveDir);
			
			// set cooldown
			cooldowns[castAbilityID] = AbilityDatabase.getAttribute(ID, castAbilityID, "Cooldown");
			
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
			
			castInputWait = false;
			return true;
		}
		
		/**
		 * 
		 * the movement handler
		 * @param e - Event.ENTER_FRAME
		 */
		override public function moveHandler(e:Event):void {
			// adjust cooldowns
			for (var a = 0; a < cooldowns.length; a++) {
				if (cooldowns[a] > 0)
					cooldowns[a]--;
			}
			
			if (forwardMovement) {
				// move forward!!
				teleportTo(x + forwardVector.x, y + forwardVector.y);
				
				// do damage!! if did damage and stop at enemy, then end ability
				var abilityWidth= AbilityDatabase.getAttribute(ID, castAbilityID, "MovementRadius");
				abilityWidth 	= abilityWidth * abilityWidth;
				var stopAtEnemy	= AbilityDatabase.getAttribute(ID, castAbilityID, "StopAtEnemy");
				var damage		= AbilityDatabase.getAttribute(ID, castAbilityID, "Damage");
				
				var enemies = MapManager.getAIUnits();
				for (a in enemies) {
					var en:StatUnit = enemies[a];
					var dx = en.x - x;
					var dy = en.y - y;
					var dist = dx * dx + dy * dy;
					
					if (dist < abilityWidth) {
						en.takeDamage(damage);
						
						if (stopAtEnemy) {
							// stop dashing and ability
							stopForwardMovement();
							enableMovement();
							endAbility();
							break;
						}
					}
				}
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
