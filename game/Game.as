package game {
	import flash.display.MovieClip;
	
	import flash.display.Bitmap;
	
	import db.CharacterDatabase;
	import db.EnemyDatabase;
	import db.MapDatabase;
	import db.SequenceDatabase;
	import db.SoundDatabase;
	import db.SpeechDatabase;
	import db.dbData.CharacterData;
	import db.dbData.MapData;

	import events.GameEventDispatcher;
	
	import game.SoundManager;	
	import game.progress.PlayerProgress;
	
	import ui.GameOverlay;

	import units.StatUnit;
	import units.Perkinite;
	import flash.geom.ColorTransform;
	import flash.geom.Rectangle;
	import flash.geom.Point;

	public class Game {
		private static var sndManager:SoundManager;
		public static var eventDispatcher:GameEventDispatcher;
		
		public static var dbEnemy:EnemyDatabase;
		public static var dbSeq:SequenceDatabase;
		public static var dbMap:MapDatabase;
		public static var dbChar:CharacterDatabase;
		public static var dbSnd:SoundDatabase;
		public static var dbSpch:SpeechDatabase;
		
		/** info about the player's progress is stored here */
		public static var playerProgress:PlayerProgress;
		
		/** the index of team the player is playing with */
		public static var teamIndex:int;
		public static var charID:String = ""; //chosen ID from char_select, DO NOT MODIFY
		public static var perkinite:Perkinite;
		public static var playerIndex:int;
		
		public static var customViewport:Boolean = false;
		public static var viewportPoint:Point = new Point(-1, -1);
		
		
		/** array of current Perkinites */
		public static var team:Array = new Array();
		
		public static var gamePause:Boolean = false;
		
		/** container movieclip for maps */
		public static var container:MovieClip;
		
		public static var world:World;
		public static var overlay:GameOverlay;
		
		public static function init():void {
			sndManager = new SoundManager();
			eventDispatcher = new GameEventDispatcher();
			
			dbEnemy	= new EnemyDatabase();
			dbSeq	= new SequenceDatabase();
			dbMap	= new MapDatabase();
			dbChar	= new CharacterDatabase();
			dbSnd	= new SoundDatabase();
			dbSpch  = new SpeechDatabase();
			playerProgress = new PlayerProgress();
		}
		
		/**
		 * set the index of the team to start with (when startGameWorld is called)
		 */
		public static function chooseTeam(index:int):void {
			teamIndex = index;
		}
		
		public static function startGameWorld(cont:MovieClip):void {
			var START_SEPARATION:int = 15;
			
			container = cont;
			gamePause = false;
			
			// create players
			Controls.startGameInputs();
			
			team = new Array();
			
			// Generic player
			var cdat:CharacterData = dbChar.getCharacterData("GK1");
			
			var char:Perkinite = new Perkinite(cdat);
			char.x = GameConstants.TILE_SIZE * playerProgress.x + (GameConstants.TILE_SIZE >> 1);
			char.y = GameConstants.TILE_SIZE * playerProgress.y + (GameConstants.TILE_SIZE >> 1);
			
			team.push(char);
			
			Game.perkinite = char;
			playerIndex = 0;
			
			
			// setup overlay
			
			overlay = new GameOverlay();	
			Game.overlay.hud.unitName1.text = Game.team[0].unitData.name;
			//Game.overlay.hud.unitName2.text = teamDat[1].name;		
			
			//WATCH OUT TODO TO-DO FIX
			Game.playerProgress.health = Game.team[0].unitData.health;
			Game.overlay.hud.HPDisplay1.text = Game.playerProgress.health;
			
			Game.overlay.hud.healthbar.FP.width = Game.playerProgress.health/Game.team[0].unitData.health * 190;
			Game.overlay.hud.visible = Game.playerProgress.hudVisible;
			Game.overlay.ehud.visible = Game.playerProgress.ehudVisible;
			Game.overlay.journal.setGoal(Game.playerProgress.goal);
			
			updateHUD();
			
			container.addChild(overlay);
			// create map/world
			world = MapManager.createWorld(Game.playerProgress.map);
			container.addChild(world);
			
			var tempIndex = container.getChildIndex(overlay);
			container.setChildIndex(overlay, container.getChildIndex(world));
			container.setChildIndex(world, tempIndex);
			
		}
		
		public static function endGameWorld():void {
			container.removeChild(world);
			container.removeChild(overlay);
			MapManager.resetWorld();
			world = null;
			
			team = new Array();
			
		}
		
		public static function moveTeam(horz:int, vert:int):void {
			if (horz == 0 && vert == 0) {
				return;
			}
			
			var lead:StatUnit = Game.perkinite;
			lead.moveDelta(horz, vert);
			
		}
		
		public static function switchPlayers(index:int):void {
			if(index < 0 || index >= Game.team.length) {
				trace("Index " + index + " out of bounds of team size " + Game.team.length);
				return;
			}
			
			if(Game.team[index] == Game.perkinite) {
				return;
			}
			
			Game.playerIndex = index;
			
			var p = Game.team[index];
			
			p.x = Game.perkinite.x;
			p.y = Game.perkinite.y;
			
			Game.perkinite.visible = false;
			p.visible = true;
			
			var tempPerkinite = Game.perkinite;			
			Game.perkinite = p;
			Game.perkinite.visible = true;
			tempPerkinite.x = -1000;
			tempPerkinite.y = -1000;
			
			Game.perkinite.path = new Array();
			if(Game.perkinite.parent == null) {
				Game.world.addUnit(Game.perkinite);
			}

			// deal with HUD stuff here
			
			updateHUD();
		}
		
		public static function updateHUD() {
			var p = Game.perkinite;
			var clonedData = Bitmap(p.unitData.icon.content).bitmapData.clone();
			
			Game.overlay.hud.faceIcon.addChild(new Bitmap(clonedData));
			Game.overlay.hud.unitName1.text = p.unitData.name;
			
			var clonedAbility1 = new Bitmap(Bitmap(p.unitData.abilities[0].icon.content).bitmapData.clone());
			clonedAbility1.width = 64;
			clonedAbility1.height = 64;
			//Game.overlay.hud.ability1.addChild(clonedAbility1);
			
			var clonedAbility2 = new Bitmap(Bitmap(p.unitData.abilities[1].icon.content).bitmapData.clone());	
			clonedAbility2.width = 64;
			clonedAbility2.height = 64;
			//Game.overlay.hud.ability2.addChild(clonedAbility2);
			
			Game.overlay.hud.setNewAbilities(new Array(clonedAbility1, clonedAbility2));
			
			var faces = new Array();
			for(var i:int = 0; i < Math.min(Game.team.length, 5); i++){
				var ic = Game.team[i].unitData.icon.content;
				var clonedIc = Bitmap(ic).bitmapData.clone();
				//Game.overlay.hud.icons[i].addChild(new Bitmap(clonedIc));
				faces.push(clonedIc);
			}
			
			Game.overlay.hud.setNewFaces(faces);

		}
		/**
		 * This is the main game loop.
		 */
		public static function update():void {
			// move player
			Controls.handleGameInputs();
			
			// screen follows player
			MapManager.update();
			
			// fps healing
			Player.updateHealing();
			
			//update journal
			Game.overlay.journal.updateGoal();
			
			Game.overlay.hud.checkOverlap();
			
			Game.playerProgress.applyBuffs(); //make this to apply to every enemy as well ugh
		}
	}
}