package ui {
	import flash.display.MovieClip;
	
	import game.Game;
	import flash.display.Bitmap;
	
	import tileMapper.ScreenRect;
	
	public class GameHUD extends MovieClip {
		
		var pid1:int, pid2:int;
		public var f_icons:Array;
		var icon_conts:Array;
		
		var faceIcons:Array;
		var abilityIcons:Array;
		//var unitHUD:HUD_Unit;
		
		//var goal:String;	//what will be displayed on the screen
		//var goalWait:int;	//how long it takes to update
		//var maxGoalWait:int;
		public function GameHUD() {
			powerbar.visible = false;
			APDisplay2.visible = false;
			
			f_icons = new Array(f1, f2, f3, f4, f5);
			
			faceIcons = new Array();
			abilityIcons = new Array();
			
			/*icons = new Array(4);
			icon_conts = new Array(4);
			for (var a = 0; a < 4; a++) {
				icon_conts[a] = this["icon_cont" + a];
			}*/
			/*goal = "";
			goalWait = 0;
			maxGoalWait = 2;
			goalDisplay.text = "";*/
		}
		
		public function checkOverlap():void {
			if(Game.perkinite.x - ScreenRect.getX() <= width && Game.perkinite.y <= 88 + 32) {
				this.alpha = this.alpha + 0.1*(0.5-this.alpha);
			} else if (Game.perkinite.x <= 64 && Game.perkinite.y <= 292 + 32) {
				this.alpha = this.alpha + 0.1*(0.5-this.alpha);
			} else {
				this.alpha = this.alpha + 0.3*(1-this.alpha);
			}
		}
		
		public function setNewAbilities(icons:Array) {
			ability1.removeChildAt(ability1.numChildren - 1);
			ability2.removeChildAt(ability2.numChildren - 1);
			abilityIcons = icons;
			ability1.addChild(abilityIcons[0]);
			ability2.addChild(abilityIcons[1]);
		}
		
		public function setNewFaces(icons:Array) {
			for(var i = 0; i < faceIcons.length; i++) {
				f_icons[i].removeChildAt(f_icons[i].numChildren - 1);
			}
			faceIcons = icons;
			for(var i = 0; i < faceIcons.length; i++) {
				f_icons[i].addChild(new Bitmap(faceIcons[i]));
			}
		}		
		/*
		public function setGoal(message:String){
			goal = message;
		}
		public function updateGoal(){
			goalWait--;
			if(goalDisplay.text.length < goal.length && goalWait <= 0){
				//SoundManager.playSound("");
				goalWait = maxGoalWait;
				goalDisplay.text = goal.substring(0, goalDisplay.text.length + 1);
			}
			
		}*/
		
		/*
		
		public function updateIcons(id1:int, id2:int) {
			pid1 = id1;
			pid2 = id2;
			
			for (var a = 0; a < 4; a++) {
				var c = icon_conts[a];
				
				if (icons[a] != null) {
					c.removeChild(icons[a]);
				}
				
				icons[a] = AbilityDatabase.getIcon((a < 2) ? id1 : id2, a % 2);
				icons[a].width = 64;
				icons[a].height = 64;
				c.addChild(icons[a]);
				c.setChildIndex(c.icon_cd, c.numChildren - 1);
			}
		}
		public function showCooldowns(p1:StatUnit, p2:StatUnit) {
			drawCooldown(p1, 0, 0);
			drawCooldown(p1, 0, 1);
			drawCooldown(p2, 1, 0);
			drawCooldown(p2, 1, 1);
		}
		function drawCooldown(char:StatUnit, charindex:int, abid:int) {
			var cd:int = char.cooldowns[abid];
			if (isNaN(cd))
				cd = 0;
			
			var maxcd = char.getMaxCooldown(abid);
			var c = icon_conts[charindex * 2 + abid].icon_cd;
			
			c.graphics.clear();
			c.graphics.beginFill(0x000000, .5);
			c.graphics.moveTo(0, 0);
			
			var perc = 2 * Math.PI * cd / maxcd;
			for (var a = 0; a < 2 * Math.PI; a += Math.PI / 70) {
				if (a > perc)
					break;
				
				c.graphics.lineTo(100 * Math.cos(a), 100 * Math.sin(a));
			}
			
			c.graphics.endFill();
		}*/
	}
}
