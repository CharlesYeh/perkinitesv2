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
		var loaded:Boolean = false;
		
		//----------STATS VARS---------
		public var unitData:UnitData;
		public var progressData:CharacterProgress;
		
		public var cooldowns:Array;
		public var abilityTargets:Array;
		public var guide:AimGuide;
		
		private var healthbar:MovieClip;
		//--------END STATS VARS-------
		
		var abilityId:int;
		var castPoint:Point;
		
		//----------FRAME VARS----------
		var prevLabel:String = ANIM_STANDING;
		public var usingAnimation:Boolean = false;
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
		
		public function setAbilityTargets(targets:Array):void {
			abilityTargets = targets;
		}
		
		protected function drawHealthbar() {
			//prevent drawing healthbar after death
			if(healthbar != null){
				var WIDTH = 50;
				var sx = -WIDTH/2;
				
				healthbar.graphics.clear();
				healthbar.graphics.lineStyle(1, 0);
				healthbar.graphics.drawRect(sx, 30, WIDTH, 5);
				
				healthbar.graphics.beginFill(0x33FF33, .7);
				healthbar.graphics.drawRect(sx, 30, WIDTH * progressData.health / unitData.health, 5);
				healthbar.graphics.endFill();
			}
		}
		
		public function takeDamage(dmg:int):void {
			progressData.health = Math.max(0, progressData.health - dmg);
			drawHealthbar();
		}
		
		public function showGuide(abilityID:int, pt:Point):void {
			if (usingAbility || cooldowns[abilityID] > 0) {
				return;
			}		
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
			swf.y = -20;
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
			return function(... args):void {
				var atk:Attack = caster.unitData.abilities[caster.abilityId];
				var func:Function = atk[functionName];
				
				func.apply(atk, args);
			};
		}
		
		//--------------FRAME FUNCTIONS--------------
		public function endAbility() {
			usingAbility = false;
			setAnimLabel(prevLabel);
		}
		//only for cutscene animations 
		public function beginAnimation(animLabel:String){
			prevLabel = animLabel;
			usingAnimation = true;
			setAnimLabel(animLabel);
		}
		public function endAnimation(){
			usingAnimation = false;
			setAnimLabel(prevLabel);
		}
		//
		public function disableMovement() {
			disabledMovement = true;
		}
		public function enableMovement() {
			disabledMovement = false;
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
			
			//change this
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
			if(usingAnimation){
				return;
			}
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
			if (!loaded || healthbar == null) return;
			
			
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
		
		public static function distance(u1:MovieClip, u2:MovieClip):Number {
			var dx:Number = u1.x - u2.x;
			var dy:Number = u1.y - u2.y;
			
			var d:Number = Math.sqrt(dx * dx + dy * dy);
			return d;
		}
		
		protected function deleteSelf():void {
			endAbility();
			setAnimLabel("standing");
			removeChild(healthbar);
			removeChild(guide);
			
			healthbar = null;
			guide = null;
			
			if (swf != null) {
				removeChild(swf);
				swf = null;
			}
			removeEventListener(Event.ENTER_FRAME, moveHandler); //prevent dead enemies
		}
		
		//make it stop running when transferring to a new map
		public function destroy(){
			deleteSelf();
		}
	}
}
