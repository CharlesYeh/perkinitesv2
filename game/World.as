package game{
	import flash.display.MovieClip;
	
	import db.dbData.MapData;
	import db.dbData.MapCharacterData;
	import db.dbData.TeleportData;

	import units.AIUnit;
	import units.GameUnit;
	import units.Teleport;
	import units.StatUnit;
	
	import aiunits.BasicAIUnit;
	
	import scripting.Sequence;
	import events.BeatEnemyEvent;
	import game.SoundManager;
	import scripting.actions.Action;
	
    public class World extends MovieClip {
		
		public var mapData:MapData;
		
		private var m_tiles:MovieClip;
		
		private var m_customs:Array;
		private var m_teleports:Array;
		private var m_enemies:Array;
		private var m_NPCs:Array;
		
        /**
		 * creates the world with MapData
         */
        public function World(mdat:MapData) {
			createWorld(mdat);
			// init npcs
        }
		
		//----------------------CREATION FUNCTIONS---------------------
		public function createWorld(mdat:MapData):void {
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
			
			m_NPCs = new Array();
			for (i in mapData.npcs) {
				var n:MapCharacterData = mapData.npcs[i];
				//createNPC(n);
			}			
			
			mdat.startSequences();
			
			SoundManager.playSong(mdat.bgmusic);
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
		}
		
		public function clearEnemy(e:AIUnit):void{
			var index = m_enemies.indexOf(e);
			
			e.destroy();
			removeChild(e);
			m_enemies.splice(index, 1);
			
			if(e.progressData.health <= 0){
				Game.eventDispatcher.dispatchEvent(new BeatEnemyEvent(e.unitData.id));
			}
		}
		
		public function clearTeleport(t:Teleport):void{
			var index = m_teleports.indexOf(t);
			
			removeChild(t);
			m_teleports.splice(index, 1);
		}
		public function clearWorld():void {
			clearWorldHelper(m_customs);
			clearWorldHelper(m_teleports);
			clearWorldHelper(m_enemies, true);
			
			m_customs = null;
			m_teleports = null;
			m_enemies = null;
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
			
			m_enemies.push(u);
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
		
		public function updateSequences():void {
			for (var i:String in mapData.sequences) {
				var seq:Sequence = mapData.sequences[i];
				seq.updateActions();
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