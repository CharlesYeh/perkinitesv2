package game{
	import flash.display.MovieClip;
	
	import db.dbData.MapData;
	import db.dbData.MapCharacterData;
	import db.dbData.TeleportData;

	import units.AIUnit;
	import units.GameUnit;
	import units.Teleport;
	import units.StatUnit;
	import units.NPCUnit;
	
	import aiunits.BasicAIUnit;
	
	import scripting.Sequence;
	import events.BeatEnemyEvent;
	import game.SoundManager;
	import scripting.actions.Action;
	import flash.geom.Point;
	
    public class World extends MovieClip {
		
		public var mapData:MapData;
		
		private var m_tiles:MovieClip;
		
		private var m_customs:Array;
		private var m_teleports:Array;
		private var m_enemies:Array;
		private var m_npcs:Array;
		
		private var activatedNPC:NPCUnit = null;
		
		public var maxEnemies:int = 0;
		
        /**
		 * creates the world with MapData
         */
        public function World(mdat:MapData) {
			createWorld(mdat);
			// init npcs
        }
		
		//----------------------CREATION FUNCTIONS---------------------
		public function createWorld(mdat:MapData):void {
			maxEnemies = 0;
			mapData = mdat;
			
			m_customs = new Array();
			
			// create a mc to put tiles into, then place objects above it
			m_tiles = new MovieClip();
			addChild(m_tiles);
			
			// init teleports
			m_teleports = new Array();
			for (var i:String in mapData.teleports) {
				var t:TeleportData = mapData.teleports[i];
				createTeleport(t);
			}
			
			// init enemies
			m_enemies = new Array();
			if(!Game.playerProgress.hasClearedArea(mapData.id)){
				for (i in mapData.enemies) {
					var e:MapCharacterData = mapData.enemies[i];
					createEnemy(e);
				}
			}
			
			m_npcs = new Array();
			for (i in mapData.npcs) {
				var n:MapCharacterData = mapData.npcs[i];
				createNPC(n);
			}			
			
			var createdUnits = Game.playerProgress.getCreatedUnits();
			
			//
			//here, check if the unit was created on the same map
			// if it's not, delete it we don't care about it yet
			for(var j = 0; j < createdUnits.length; j++){
				var dat = createdUnits[j];
				
				var cdat = new MapCharacterData();
				
				if (Game.playerProgress.map != dat.map) {
					continue;
				}
				if(dat.subtype == "enemy"){
					cdat.parseData(dat);
					createEnemy(cdat);
				}
				else if(dat.subtype == "npc"){
					cdat.parseData(dat);
					
					createNPC(cdat);	
					m_npcs[m_npcs.length-1].animLabel = dat.animation;
					m_npcs[m_npcs.length-1].beginAnimation(dat.animation);
				}
			}
			
			
			//Game.playerProgress.setCreatedUnits(new Array());
			
			mdat.startSequences();
			if(!Game.playerProgress.loadedSong){
				if(mdat.bgmusic != null){
					//SoundManager.playSong(mdat.bgmusic);				
				}
				else{
					SoundManager.endSong();
				}				
			}
			else{
				if(Game.playerProgress.currentSong != null){
					//SoundManager.playSong(Game.playerProgress.currentSong);				
				}
				else{
					SoundManager.endSong();
				}				
				Game.playerProgress.loadedSong = false;
			}
		}
		
		public function getTilesClip():MovieClip {
			return m_tiles;
		}
		public function clearCustom(c:MovieClip):void{
			var index = m_customs.indexOf(c);
			if(c.parent != null){
				removeChild(c);
			}
			m_customs.splice(index, 1);
			c = null;
		}
		
		public function clearEnemy(e:AIUnit):void{
			
			var index = m_enemies.indexOf(e);
			e.destroy();
			removeChild(e);
			m_enemies.splice(index, 1);
			
			if(e.progressData.health <= 0){
				Game.eventDispatcher.dispatchEvent(new BeatEnemyEvent(e.unitData.id));
			}
			
			e = null; //garbage collect this on the next GC cycle?
			
		}
		
		public function clearTeleport(t:Teleport):void{
			var index = m_teleports.indexOf(t);
			
			removeChild(t);
			m_teleports.splice(index, 1);
		}
		
		public function clearNPC(npc:NPCUnit):void{
			var index = m_npcs.indexOf(npc);
			if(npc.parent != null){
				removeChild(npc);
			}
			m_npcs.splice(index, 1);			
		}
		
		public function clearWorld():void {
			clearWorldHelper(m_customs);
			clearWorldHelper(m_teleports);
			clearWorldHelper(m_enemies, true);
			clearWorldHelper(m_npcs);
			
			m_customs = null;
			m_teleports = null;
			m_enemies = null;
			m_npcs = null;
			
			while(numChildren > 0){
				removeChildAt(0);
			}
		}
		
		private function clearWorldHelper(clips:Array, destroy:Boolean=false):void {
			for (var i:String in clips) {
				removeChild(clips[i]);
				
				if (destroy) {
					(clips[i] as StatUnit).destroy();
				}
			}
		}
		
		//-------------------------UNIT CREATE------------------------
		/**
		 * custom-add units
		 */
		public function addUnit(u:MovieClip):void {
			m_customs.push(u);
			addChild(u);
		}
		
		public function removeUnits(u:Array):void {
			for(var i:String in u){
				removeUnitHelper(u[i]);
			}
		}
		private function removeUnitHelper(u:MovieClip):void{
			m_customs.splice(m_customs.indexOf(u), 1);
			if(u.parent != null){ 
				removeChild(u);
			}
		}
		/**
		 * add this enemy to the map
		 */
		public function createEnemy(edat:MapCharacterData):void {
			var u:AIUnit = AIUnit.createAIUnit(edat.id);
			u.x = (edat.position.x * GameConstants.TILE_SIZE) + (GameConstants.TILE_SIZE >> 1);
			u.y = (edat.position.y * GameConstants.TILE_SIZE) + (GameConstants.TILE_SIZE >> 1);
			u.setAbilityTargets(Game.team);
			
			switch (edat.direction) {
				case "east":
				case "right":
					u.updateDirection(0);
					break;
					
				case "north":
				case "up":
					u.updateDirection(1);
					break;
					
				case "west":
				case "left":
					u.updateDirection(2);
					break;
					
				case "south":
				case "down":
					u.updateDirection(3);
					break;
			}
			
			m_enemies.push(u);
			addChild(u);
			maxEnemies++;
		}
		
		public function createSpawnEnemy(id:String, xpos:int, ypos:int, dir:String):AIUnit {
			var u:AIUnit = AIUnit.createAIUnit(id);
			u.x = xpos;
			u.y = ypos;
			u.setAbilityTargets(Game.team);
			
			switch (dir) {
				case "east":
				case "right":
					u.updateDirection(0);
					break;
					
				case "north":
				case "up":
					u.updateDirection(1);
					break;
					
				case "west":
				case "left":
					u.updateDirection(2);
					break;
					
				case "south":
				case "down":
					u.updateDirection(3);
					break;
			}
			
			m_enemies.push(u);
			addChild(u);
			maxEnemies++;
			return u;
		}
		
		public function createNPC(npcdat:MapCharacterData):void {
			var u:NPCUnit = new NPCUnit(npcdat);
			u.x = (npcdat.position.x * GameConstants.TILE_SIZE) + (GameConstants.TILE_SIZE >> 1);
			u.y = (npcdat.position.y * GameConstants.TILE_SIZE) + (GameConstants.TILE_SIZE >> 1);
			
			var directions = new Array("east", "north", "west", "south");
			u.updateDirection(directions.indexOf(npcdat.direction));
			m_npcs.push(u);
			addChild(u);
		}
				
		public function createTeleport(tdat:TeleportData):void {
			// check conditions, only create if all true
			var enableTele:Boolean = true;
			for (var i:String in tdat.conditions) {
				var cond:Action = tdat.conditions[i];
				cond.act();
				
				enableTele = enableTele && cond.isComplete();
			}
			
			var t:Teleport = new Teleport(tdat);
			t.enabled = enableTele;
			
			m_teleports.push(t);
			addChild(t);
		}
		//-------------------------------------------------------------
		public function getCustoms():Array{
			return m_customs;
		}
		public function getEnemies():Array {
			return m_enemies;
		}
		public function getTeleports():Array{
			return m_teleports;
		}
		public function getNPCs():Array{
			return m_npcs;
		}		
		
		public function getActivatedNPC():NPCUnit {
			return activatedNPC;
		}
		
		public function checkTeleports(su:GameUnit):TeleportData {
			var sx = Math.floor(su.x / GameConstants.TILE_SIZE);
			var sy = Math.floor(su.y / GameConstants.TILE_SIZE);
			
			for (var i:String in m_teleports) {
				var t:Teleport = m_teleports[i];
				if (!t.enabled) {
					continue;
				}
				
				if (sx == t.teleData.entryX && sy == t.teleData.entryY) {
					// change map!
					return t.teleData;
				}
			}
			
			return null;
		}
		
		public function checkNPCs():void {
			if(activatedNPC != null) {
				return;
			}
						
			for (var i:String in m_npcs) {
				var t:NPCUnit = m_npcs[i];
				
				var dx = t.x - Game.team[0].x;
				var dy = t.y - Game.team[0].y;
				var dist = Math.sqrt(dx * dx + dy * dy);
				
				if(dist <= 64){
					activatedNPC = t;
					activatedNPC.turnTo(new Point(Game.team[0].x, Game.team[0].y));
					activatedNPC.updateDirection(activatedNPC.moveDir);
					for (var i:String in activatedNPC.mapCharacterData.actions) {
						var seq:Sequence = activatedNPC.mapCharacterData.actions[i];
						seq.start();
					}							
					break;
				}
			}
		}		
		
		public function updateSequences():void {
			if (activatedNPC != null) {
				for (var i:String in activatedNPC.mapCharacterData.actions) {
					var seq:Sequence = activatedNPC.mapCharacterData.actions[i];
					seq.updateActions();
					
					if(seq.update()) {
						activatedNPC.resetDirection();
						activatedNPC = null;
						seq.reset();
					}
				}		
			} else {
				for (var i:String in mapData.sequences) {
					var seq:Sequence = mapData.sequences[i];
					seq.updateActions();
				}				
			}
			
			for (i in m_teleports) {
				var tele:Teleport = m_teleports[i];
				
				for (var j:String in tele.teleData.conditions) {
					var cond:Action = tele.teleData.conditions[j];
					tele.enabled = enabled && cond.update();
				}
			}
		}
		
	}
}