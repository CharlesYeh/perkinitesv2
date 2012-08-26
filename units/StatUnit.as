package units {
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.display.MovieClip;
	import flash.geom.Point;
	
	import tileMapper.TileMap;
	import db.AbilityDatabase;
	import db.dbData.UnitData;
	import attacks.Attack;
	
	import game.GameConstants;
	import game.progress.CharacterProgress;

	public class StatUnit extends GameUnit {
		
		static const DIRECTIONS:Array = new Array("east", "north", "east", "south");

		static const ANIM_STANDING:String	= "standing";
		static const ANIM_FF:String			= "friend_finale";
		static const ANIM_WALKING:String	= "walking";
		static const ANIM_ABILITY1:String	= "ability1";
		static const ANIM_ABILITY2:String	= "ability2";
		static const ANIM_ABILITY3:String	= "ability3";
		
		/** all the frame functions called by the animation */
		static const frameFuncs:Array = new Array("beginForwardMovement", "stopForwardMovement",
										"dealDamage", "applyBuffs", "shootSkillshot",
										"teleport", "teleportPartner");
		
		/** the swf sprite asset */
		var swf;
		
		var animLabel:String = ANIM_STANDING;
		var animClip:MovieClip;
		var loaded = false;
		
		//----------STATS VARS---------
		public var unitData:UnitData;
		public var progressData:CharacterProgress;
		
		public var cooldowns:Array;
		var healthbar:MovieClip;
		public var guide:AimGuide;
		//--------END STATS VARS-------
		
		var abilityId:int;
		var castPoint:Point;
		
		//----------FRAME VARS----------
		var prevLabel:String = ANIM_STANDING;
		var usingAbility:Boolean	= false;
		var disabledMovement:Boolean= false;
		var forwardVector:Point = null;
		//--------END FRAME VARS--------
		
		public function StatUnit(udat:UnitData) {
			super();
			
			unitData = udat;
			progressData = new CharacterProgress();
			
			animLabel = ANIM_STANDING;
			
			cooldowns = new Array(10);
			
			progressData.health = unitData.health;
			
			// draw health bar
			healthbar = new MovieClip();
			addChild(healthbar);
			drawHealthbar();
			
			guide = new AimGuide();
			addChildAt(guide, 0);
			guide.visible = false;
			
		}
		
		protected function drawHealthbar() {
			var WIDTH = 50;
			var sx = -WIDTH/2;
			
			healthbar.graphics.clear();
			healthbar.graphics.lineStyle(1, 0);
			healthbar.graphics.drawRect(sx, 30, WIDTH, 5);
			
			healthbar.graphics.beginFill(0x33FF33, .7);
			healthbar.graphics.drawRect(sx, 30, WIDTH * progressData.health / unitData.health, 5);
			healthbar.graphics.endFill();
		}
		
		public function takeDamage(dmg:int):void {
			progressData.health = Math.max(0, progressData.health - dmg);
			drawHealthbar();
		}
		
		public function showGuide(abilityID:int, pt:Point):void {
			if(guide.visible){
				unitData.abilities[abilityID].updateGuide(this, pt);
			}
			else{
				unitData.abilities[abilityID].showGuide(this, pt);
			}
		}
		public function hideGuide(){
			guide.stop();
			guide.visible = false;
		}
		
		protected function loadSwf() {
			swf = new Loader();
			swf.load(getSprite());
			addChild(swf);
			
			swf.contentLoaderInfo.addEventListener(Event.COMPLETE, completeLoad);
		}
		
		/**
		 * load the sprite swf for this unit
		 */
		protected function getSprite():URLRequest {
			return new URLRequest(GameConstants.PATH_SPRITES + unitData.sprite + GameConstants.SPRITES_EXT);
		}
		
		function completeLoad(e):void {
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
			
			// attach ability frame functions
			for (var i:String in frameFuncs) {
				var caster:StatUnit = this;
				var functionName:String = frameFuncs[i];
				
				var ff:Function = generateFrameFunction(caster, functionName);
				swf.content.char[functionName] = ff;
			}
		}
		
		private function generateFrameFunction(caster:StatUnit, functionName:String):Function {
			return function():void {
				var atk:Attack = caster.unitData.abilities[caster.abilityId];
				var func:Function = atk[functionName];
				
				func();
			};
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
			/*forwardMovement = true;
			
			var dx = castPoint.x - x;
			var dy = castPoint.y - y;
			var d = Math.sqrt(dx * dx + dy * dy);
			dx = dx / d;
			dy = dy / d;
			
			forwardVector = new Point(dx, dy);*/
		}
		public function stopForwardMovement() {
			/*forwardMovement = false;
			clearPath();*/
		}
		public function dealDamage(abilityID:int) {
			//castMouseTarget.takeDamage(AbilityDatabase.getAttribute(ID, abilityID, "Damage"));
		}
		public function shootSkillshot(array:Array) {
			/*if (this.parent == null)
				return;
			
			for(var i = 0; i < array.length; i++){
				
				var ss = array[i];
				ss.parent.removeChild(ss);
				this.parent.addChild(ss);
				
				if(moveDir == 2){
					ss.x *= -1;
					ss.rotation = 180;
				}
				
				// move relative to shooter
				ss.x += this.x;
				ss.y += this.y;
				
				// direction to shoot skillshot
				var rad;
				
				switch (AbilityDatabase.getTargetType(ID, castAbilityID)) {
				case AbilityDatabase.ATKTYPE_TARGET:
					rad = Math.atan2(castMouseTarget.y - ss.y, castMouseTarget.x - ss.x);
					ss.target = castMouseTarget;
					ss.addEventListener(Event.ENTER_FRAME, skillshotHoming);
					break;
				case AbilityDatabase.ATKTYPE_SCAST:
					
					//break;
				default:
					rad = Math.atan2(castMousePoint.y - ss.y, castMousePoint.x - ss.x);
					ss.addEventListener(Event.ENTER_FRAME, skillshotMover);
				}
				
				ss.range = AbilityDatabase.getAttribute(ID, castAbilityID, "Range");
				ss.ms = int(AbilityDatabase.getAttribute(ID, castAbilityID, "SkillshotSpeed"));
				ss.vx = ss.ms * Math.cos(rad);
				ss.vy = ss.ms * Math.sin(rad);
				ss.dist = 0;
				
				ss.abilityWidth	= AbilityDatabase.getAttribute(ID, castAbilityID, "SkillshotWidth");
				ss.damage		= AbilityDatabase.getAttribute(ID, castAbilityID, "Damage");
				ss.stopAtFirst	= true;
				
			}*/
		}
		
		function applyBuffs() {
			
		}
		
		function skillshotMover(e:Event) {
			/*var ss = e.target;
			
			ss.x += ss.vx;
			ss.y += ss.vy;
			ss.dist += ss.ms;
			
			// test collisions
			if (testSkillshotCollision(ss, ss.abilityWidth, ss.damage, ss.stopAtFirst) || ss.dist > ss.range) {
				ss.parent.removeChild(ss);
				ss.removeEventListener(Event.ENTER_FRAME, skillshotMover);
			}*/
		}
		function skillshotHoming(e:Event) {
			/*var ss = e.target;
			
			// test collision with target
			var dx = ss.target.x - ss.x;
			var dy = ss.target.y - ss.y;
			var dist = dx * dx + dy * dy;
			
			if (dist < ss.abilityWidth) {
				ss.target.takeDamage(ss.damage);
				
				ss.parent.removeChild(ss);
				ss.removeEventListener(Event.ENTER_FRAME, skillshotHoming);
				return;
			}
			
			// movement
			var rad = Math.atan2(ss.target.y - ss.y, ss.target.x - ss.x);
			ss.x += Math.cos(rad) * ss.ms;
			ss.y += Math.sin(rad) * ss.ms;*/
		}
		function teleport() {
			/*teleportTo(castPoint.x, castPoint.y);
			clearPath();*/
		}
		function teleportPartner() {
			/*partner.teleportTo(castPoint.x, castPoint.y);
			partner.clearPath();*/
		}
		//------------END FRAME FUNCTIONS------------
		
		public function castAbility(abID:int, mousePos:Point):Boolean {
			if(!loaded){
				return false;
			}
			if (usingAbility || cooldowns[abID] > 0) {
				return false;
			}
			
			abilityId = abID;
			castPoint = mousePos;
			
			// test for range
			var ability:Attack = unitData.abilities[abilityId];
			if (!ability.inRange(this, castPoint)) {
				return false;
			}
			
			ability.castAbility(this, mousePos);
			
			// look at direction of ability
			turnTo(castPoint);
			updateDirection(moveDir);
			
			// set cooldown
			cooldowns[abilityId] = ability.cd;
			
			usingAbility = true;
			prevLabel = animLabel;
			
			switch (abilityId) {
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
				if (cooldowns[a] > 0) {
					cooldowns[a]--;
				}
			}
			
			// update ability if animation is playing
			if (usingAbility) {
				var atk:Attack = unitData.abilities[abilityId];
				atk.castInProgress(this);
				
				return;
			}
			
			if (disabledMovement) {
				return;
			}
			
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
		
		public static function distance(u1:StatUnit, u2:StatUnit):Number {
			var dx:Number = u1.x - u2.x;
			var dy:Number = u1.y - u2.y;
			
			var d:Number = Math.sqrt(dx * dx + dy * dy);
			return d;
		}
		
		protected function deleteSelf():void {
			removeChild(healthbar);
			removeChild(guide);
			
			healthbar = null;
			guide = null;
			
			if (swf != null) {
				removeChild(swf);
				swf = null;
			}
		}
		
		//make it stop running when transferring to a new map
		/*public function destroy(){
			deleteSelf();
		}*/
	}
}
