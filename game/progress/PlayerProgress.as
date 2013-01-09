package game.progress {
	import game.Game;
	import game.Controls;
	
	import tileMapper.TileMap;
	
	import units.StatUnit;
	
	import flash.net.SharedObject;
	import flash.net.registerClassAlias;
	import flash.utils.Dictionary;
	
	public class PlayerProgress {
		
		private var sharedObj:SharedObject;
		
		public var id:String;
		
		public var flexPoints:int;
		
		/** array of all the sequences the player has already completed */
		public var completedSequences:Array = new Array();
		
		/** array of all the sequences the player has already cleared */
		public var clearedAreas:Array = new Array();
		
		/** dictionary of "item name" -> "boolean" */
		public var items:Dictionary = new Dictionary();
		
		/** character level ups achieved */
		public var levelUps:int;
		
		/** chosen team */
		public var chosenTeam:Array;
		
		/** set of the unlocked teams */
		public var unlockedTeams:Dictionary = new Dictionary();
		
		/** health of the team */
		public var health;
		
		/** map position of the player */
		public var map:String;
		public var x:int;
		public var y:int;
		
		public function PlayerProgress() {
			registerClassAlias("pp", PlayerProgress);
			registerClassAlias("a", Array);
			registerClassAlias("d", Dictionary);
			
			sharedObj = SharedObject.getLocal("PERKINITES");
		}
		
		public function addCompletedSequence(id:String):void {
			completedSequences.push(id);
			
			//----------------AUTO-SAVE----------------
			save();
		}
		
		public function hasCompletedSequence(id:String):Boolean {
			return completedSequences.indexOf(id) != -1;
		}
		
		public function unlockItem(item:String):void {
			items[item] = true;
		}
		
		public function hasUnlockedItem(item:String):Boolean {
			return items.hasOwnProperty(item);
		}
		
		public function addClearedArea(id:String):void {
			clearedAreas.push(id);
		}
		public function hasClearedArea(id:String):Boolean {
			return clearedAreas.indexOf(id) != -1;
		}		
		
		public function unlockTeam(team:Array):void {
			unlockedTeams[team.join("_")] = true;
		}
		
		public function hasUnlockedTeam(team:Array):Boolean {
			return unlockedTeams.hasOwnProperty(team.join("_"));
		}
		
		public function newGame():void {
			id = "PERKINITES";
			flexPoints = 0;
			
			map = "perkins_2f";
			x = 5;
			y = 10;
			
			completedSequences = new Array();
			items = new Dictionary();
			
			unlockedTeams = new Dictionary();
			unlockedTeams["CY_NM"] = true;
			unlockedTeams["EH_JT"] = true;
			unlockedTeams["CK_CM"] = true;
			unlockedTeams["HV_HQ"] = true;			
			
			health = -1;
		}
		
		public function loadGame(soId:String):void {
			var prog:Object = sharedObj.data[soId];
			
			x = prog.x;
			y = prog.y;
			map = prog.map;
			
			id		= soId;
			flexPoints = prog.flexPoints;
			
			completedSequences = prog.completedSequences;
			clearedAreas = prog.clearedAreas;
			items	= prog.items;
			
			unlockedTeams = prog.unlockedTeams;
			
			health = prog.health;
		}
		
		public function save():void {
			var so:SharedObject = sharedObj;
			sharedObj = null;
			
			var player:StatUnit = Game.team[0];
			x = player.x / TileMap.TILE_SIZE;
			y = player.y / TileMap.TILE_SIZE;
			map = Game.world.mapData.id;
			
/*			var uteams = unlockedTeams;
			unlockedTeams = uteams();*/
			
			// save this object without reference to SharedObject
			so.data[id] = this;
			so.flush();
			
			// restore variables
			sharedObj = so;
			//unlockedTeams = uteams;
		}
		
		public function takeDamage(dmg:int){
/*			if(progressData.health > 0){
				progressData.health = Math.max(0, progressData.health - dmg);
				drawHealthbar();
				
				if(progressData.health <= 0){
					Controls.enabled = false;
					Game.overlay.gameover.enable();
				}				
			}		*/
			if(health > 0){
				health = Math.max(0, health - dmg);
				for (var i:String in Game.team) {
					var u:StatUnit = Game.team[i];
					u.progressData.health = health;
				}
				
				//make sure playerprogress health is synced with game's playerprogress health
				Game.playerProgress.health = Game.team[0].progressData.health;
				
				Game.overlay.hud.HPDisplay1.text = Game.playerProgress.health;
				Game.overlay.hud.HPDisplay2.text = Game.playerProgress.health;
								
				if(health <= 0){
					Controls.enabled = false;
					Game.overlay.gameover.enable();
				}
				
			}	
		}
	}
	
}
