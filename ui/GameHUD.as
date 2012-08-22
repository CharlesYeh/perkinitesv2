package ui {
	import flash.display.MovieClip;
	
	public class GameHUD extends MovieClip {
		
		var pid1:int, pid2:int;
		var icons:Array;
		var icon_conts:Array;
		/*
		public function GameHUD() {
			icons = new Array(4);
			icon_conts = new Array(4);
			for (var a = 0; a < 4; a++) {
				icon_conts[a] = this["icon_cont" + a];
			}
		}
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
