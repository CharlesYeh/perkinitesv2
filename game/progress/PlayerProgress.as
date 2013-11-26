package game.progress {
	import flash.net.SharedObject;
	import flash.net.registerClassAlias;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

	import game.Game;
	import game.Controls;
	import game.SoundManager;

	import tileMapper.TileMap;
	
	import ui.GameOverlay;

	import units.AIUnit;
	import units.StatUnit;

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
		
		/** chosen team */
		public var chosenTeam:Array;
		
		/** set of the unlocked teams */
		public var unlockedTeams:Dictionary = new Dictionary();
		public var lockedTeams:Dictionary = new Dictionary();
		
		/** health of the team */
		public var health;
		
		/** map position of the player */
		public var map:String;
		public var x:int;
		public var y:int;
		
		/** difficulty of the game */
		public var difficulty:int;
		
		/** current information about game determined by actions */
		public var controlsEnabled:Boolean;	//for Controls
		public var aiEnabled:Boolean;	//for AIUnit
		public var currentSong:String;	//for SoundManager
		public var loadedSong:Boolean = false;	//for World/SoundManager
		public var hudVisible:Boolean = false;
		public var ehudVisible:Boolean = false;
		public var goal:String = "";
		
		public var createdUnits:Array = new Array();
		public var deletedUnits:Array = new Array();
		
		/** prevent auto save of shared objects **/
		public var tempItems:Dictionary = new Dictionary();
		
		public function PlayerProgress() {
			registerClassAlias("pp", PlayerProgress);
			registerClassAlias("a", Array);
			registerClassAlias("d", Dictionary);
			
			sharedObj = SharedObject.getLocal("PERKINITES");
		}
		
		public function addCompletedSequence(id:String):void {
			completedSequences.push(id);
		}
		
		public function hasCompletedSequence(id:String):Boolean {
			return completedSequences.indexOf(id) != -1;
		}
		
		public function unlockItem(item:String):void {
			tempItems[item] = true;		
		}
		
		public function hasUnlockedItem(item:String):Boolean {
			return items.hasOwnProperty(item) || tempItems.hasOwnProperty(item);
		}
		
		public function addClearedArea(id:String):void {
			clearedAreas.push(id);
			
			//----------------AUTO-SAVE----------------
			save();
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
		
		public function hasLockedTeam(team:Array):Boolean {
			return lockedTeams.hasOwnProperty(team.join("_"));
		}		
		
		public function newGame():void {
			id = "PERKINITES";
			flexPoints = 0;
			
			map = "ratty_entrance"; //"jos_outer_corridor"; //perkins_2f
			x = 7; //5;
			y =  4; //20; //10
			
			completedSequences = new Array();
			items = new Dictionary();
			
			unlockedTeams = new Dictionary();
			unlockedTeams["CY_NM"] = true;
			unlockedTeams["EH_JT"] = true;
			unlockedTeams["CK_CM"] = true;
			unlockedTeams["HV_HQ"] = true;			
			lockedTeams = new Dictionary();
			
			health = -1;
			
			clearedAreas = new Array();
			items = new Dictionary();
			
			difficulty = 0;			//at the moment, set it to the easiest
			
			Controls.enabled = true;
			AIUnit.enabled = true;
			currentSong = "";
			loadedSong = false;
			hudVisible = false;
			ehudVisible = false;	
			goal = "";
			
			createdUnits = new Array();
		}
		
		public function nextLevel(mapName:String, xpos:int, ypos:int):void {
			this.map = mapName;
			
			var player:StatUnit = Game.team[0];
			player.x = xpos * TileMap.TILE_SIZE;
			player.y = ypos * TileMap.TILE_SIZE;
			
			//disable the last team played
			
			health = -1;
			
			Controls.enabled = true;
			AIUnit.enabled = true;
			currentSong = "";
			loadedSong = false;
			hudVisible = false;
			ehudVisible = false;	
			goal = "";	
			
						
			Game.playerProgress = this;
			lockedTeams[chosenTeam.join("_")] = true;
			
			save();
			
			
			Game.container.gotoAndStop(1, "menu");
			Game.container.gotoAndStop("char_select");

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
			items = prog.items;
			
			unlockedTeams = prog.unlockedTeams;
			lockedTeams = prog.lockedTeams;
			
			health = prog.health;
			
			difficulty = prog.difficulty;
			
			Controls.enabled = prog.controlsEnabled;
			AIUnit.enabled = prog.aiEnabled;
			currentSong = prog.currentSong;
			loadedSong = true;
			hudVisible = prog.hudVisible;
			ehudVisible = prog.ehudVisible;	
			goal = prog.goal;
			
			createdUnits = prog.createdUnits;

			
			trace("LOADED UNITS");

			for(var i = 0; i < createdUnits.length; i++){
				trace("Unit: " + createdUnits[i].id);				
			}
			/*trace("LOADED SEQUENCES");
			for(var i = 0; i < completedSequences.length; i++){
				trace("Loaded Unit: " + completedSequences[i]);				
			}*/
		}
		
		public function save():void {
			if (Game.playerProgress.health <= 0) {
				return;
			}
			var so:SharedObject = sharedObj;
			sharedObj = null;
			
			var player:StatUnit = Game.team[0];
			x = player.x / TileMap.TILE_SIZE;
			y = player.y / TileMap.TILE_SIZE;
			map = Game.playerProgress.map;
			
/*			var uteams = unlockedTeams;
			unlockedTeams = uteams();*/
			
			controlsEnabled = Controls.enabled;
			aiEnabled = AIUnit.m_enabled;
			currentSong = SoundManager.currentSong;
			hudVisible = Game.overlay.hud.visible;
			ehudVisible = Game.overlay.ehud.visible;
			
			
			for(var i = 0; i < deletedUnits.length; i++){
				createdUnits.splice(createdUnits.indexOf(deletedUnits[i]), 1);
			}
			trace("CREATED UNITS:");
			for(var i = 0; i < createdUnits.length; i++){
				trace("Created Unit: " + createdUnits[i].id);				
			}
			
			goal = Game.overlay.journal.goal;
			
			for (var key:* in tempItems) {
        		items[key] = true;
    		}
			// save this object without reference to SharedObject
			so.data[id] = this.clone(this);
			so.flush();
			
			// restore variables
			sharedObj = so;
			//unlockedTeams = uteams;
		}
		
		public function takeDamage(dmg:int){
			if(!AIUnit.m_enabled){
				return;
			}
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
				Game.overlay.hud.healthbar.FP.width = Game.playerProgress.health/int(Game.overlay.hud.HPDisplay2.text) * 190;
								
				if(health <= 0){
					Controls.enabled = false;
					Game.overlay.gameover.enable();
				}
				
			}	
		}
		
		public function getMaxHealth():int {
			return Game.team[0].unitData.health;
		}
		
		public function getCreatedUnits():Array {
			return createdUnits;
		}
		
		public function setCreatedUnits(units:Array):void {
			createdUnits = units;
		}
		
		public function addCreatedUnit(unit:Object):void {
			createdUnits.push(unit);
		}
		
		private function clone(obj:Object):Object {
			var temp:ByteArray = new ByteArray();
			temp.writeObject(obj);
			temp.position = 0;
			return temp.readObject();
		}		
	}
}
