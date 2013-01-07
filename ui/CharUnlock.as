package ui {
	import flash.display.MovieClip;
	
	import db.*;
	
	import db.dbData.CharacterData;
	import db.dbData.AttackData;
	
	import game.Game;
	
	import flash.display.MovieClip;
	import flash.display.Loader;
	
	import flash.filters.GlowFilter;
	
	import flash.events.MouseEvent;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	public class CharUnlock extends MovieClip {
		var entries:Array = new Array();
		var chosenTeam:int = 0;
		var glowDisplay=new GlowFilter(0xFF9900, 100, 20, 20, 1, 5, true, false);
		var glowEntry = new GlowFilter(0xFFFFFF, 100, 20, 20, 1, 10, true, false);
		var glowBegin = new GlowFilter(0xFF9900, 100, 20, 20, 1, 10, true, false);
		
		public var done;
		
		public function CharUnlock(){
			visible = false;
		}
		
		public function enable(){
			mouseChildren = true;
			visible = true;
			done = false;
			scrollPane.source = playerList;
			beginButton.buttonText.text = "Unlock!";
			beginButton.mouseChildren = false;
			beginButton.glowF = glowBegin;
			beginButton.addEventListener(MouseEvent.MOUSE_OVER, entryOverHandler);
			beginButton.addEventListener(MouseEvent.MOUSE_OUT, entryOutHandler);
			beginButton.addEventListener(MouseEvent.CLICK, startLevel);
			//stage.addEventListener(KeyboardEvent.KEY_DOWN, charKeyHandler);

			// show available teams in middle
			showEntries();

		}
		public function disable(){
			visible = false;
			done = true;
			beginButton.removeEventListener(MouseEvent.MOUSE_OVER, entryOverHandler);
			beginButton.removeEventListener(MouseEvent.MOUSE_OUT, entryOutHandler);
			beginButton.removeEventListener(MouseEvent.CLICK, startLevel);
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, charKeyHandler);
			
			for (var e in entries) {
				var entry = entries[e];
				entry.removeEventListener(MouseEvent.MOUSE_OVER, entryOverHandler);
				entry.removeEventListener(MouseEvent.MOUSE_OUT, entryOutHandler);
				entry.removeEventListener(MouseEvent.CLICK, clickHandler);
				playerList.removeChild(entry);
			}
			
			entries = new Array();
			

		}
		function showEntries() {
			var allTeams:Array	= Game.dbChar.getUnlockedTeams();
			
			// must only show available Units, not all Units!
			for (var i = 0; i < allTeams.length; i++) {
				var team:Array = allTeams[i];
				

				var dat:Array = Game.dbChar.getTeamCharacterData(i);
				
				var entry = new Entry();
				entry.playerName1.text = dat[0].name;
				entry.playerName2.text = dat[1].name;
				entry.id = i;
				entry.gotoAndStop(1);
				entry.glowF = glowEntry;
				
				entry.alpha = 0.5;
				// skip unlocked teams
				if (!Game.playerProgress.hasUnlockedTeam(team)) {
					entry.addEventListener(MouseEvent.MOUSE_OVER, entryOverHandler);
					entry.addEventListener(MouseEvent.MOUSE_OUT, entryOutHandler);
					entry.addEventListener(MouseEvent.CLICK, clickHandler);
					entry.alpha = 1;
				
				}
				
				
				// GOTTA ADD
				playerList.addChild(entry);
				entry.mouseChildren = false;
				entry.x = 0;
				entry.y = 16 * i;
				entries.push(entry);
			}
		}
		function chooseTeam(team) {
			chosenTeam = team;
			var dat:Array = Game.dbChar.getTeamCharacterData(chosenTeam);
			
			// activate entry in middle
			entries[chosenTeam].gotoAndStop(2);
		}
		
		function startLevel(e) {
			// pressed the start button
			//var sound = new se_chargeup();
			//sound.play();
			
			//fix
			var allTeams:Array	= Game.dbChar.getUnlockedTeams();
			Game.playerProgress.unlockTeam(allTeams[chosenTeam]);
			done = true;
		}
		function charKeyHandler(e) {
			if (e.keyCode == Keyboard.SPACE) {
				startLevel(e);
			}
		}
		
		
		
		function clickHandler(e) {
			// choose entry
			entries[chosenTeam].gotoAndStop(1);
			
			//var sound = new se_timeout();
			//sound.play();
			
			chooseTeam(e.target.id);
		}
		function entryOverHandler(e) {
			e.target.filters = [e.target.glowF];
		}
		function entryOutHandler(e) {
			e.target.filters = [];
		}
	}



}