﻿import db.*;

import db.dbData.CharacterData;
import db.dbData.AttackData;
import db.dbData.MapData;
import game.Game;

import game.SoundManager;

import flash.display.MovieClip;
import flash.display.Loader;

var fIcon1:Loader = new Loader();
var fIcon2:Loader = new Loader();
faceIcon1.addChild(fIcon1);
faceIcon2.addChild(fIcon2);

var entries:Array = new Array();
var chosenTeam:int = 0;

scrollPane.source = playerList;

var glowDisplay=new GlowFilter(0xFF9900, 100, 20, 20, 1, 5, true, false);
var glowEntry = new GlowFilter(0xFFFFFF, 100, 20, 20, 1, 10, true, false);
var glowBegin = new GlowFilter(0xFF9900, 100, 20, 20, 1, 10, true, false);

beginButton.buttonText.text = "Start!";
beginButton.mouseChildren = false;
beginButton.glowF = glowBegin;

backButton.buttonText.text = "<- Back";
backButton.mouseChildren = false;
backButton.glowF = glowBegin;


beginButton.addEventListener(MouseEvent.MOUSE_OVER, entryOverHandler);
beginButton.addEventListener(MouseEvent.MOUSE_OUT, entryOutHandler);
beginButton.addEventListener(MouseEvent.CLICK, startLevel);

backButton.addEventListener(MouseEvent.MOUSE_OVER, entryOverHandler);
backButton.addEventListener(MouseEvent.MOUSE_OUT, entryOutHandler);
backButton.addEventListener(MouseEvent.CLICK, returnToDifficulty);

stage.addEventListener(KeyboardEvent.KEY_DOWN, charKeyHandler);

for (a = 0; a <= 1; a++) {
	var b1 = playerDisplay1["button" + a];
	var b2 = playerDisplay2["button" + a];
	
	b1.text = "Page " + (a + 1);
	b2.text = "Page " + (a + 1);
	
	b1.mouseChildren = false;
	b2.mouseChildren = false;
	b1.id = a;
	b2.id = a;
	
	b1.addEventListener(MouseEvent.CLICK, pageHandler);
	b2.addEventListener(MouseEvent.CLICK, pageHandler);
}


playerDisplay1.button0.buttonText.text = "Stats";
playerDisplay1.button1.buttonText.text = "Techs";
playerDisplay2.button0.buttonText.text = "Stats";
playerDisplay2.button1.buttonText.text = "Techs";

// show available teams in middle
showEntries();

function showEntries() {
	var allTeams:Array	= Game.dbChar.getUnlockedTeams();
	
	// must only show available Units, not all Units!
	var counter = 0;
	var select = false;
	for (var i = 0; i < allTeams.length; i++) {
		var team:Array = allTeams[i];
		
		// skip locked teams
		if (!Game.playerProgress.hasUnlockedTeam(team)) {
			continue;
		}
		
		var dat:Array = Game.dbChar.getTeamCharacterData(i);
		var entry = new Entry();
		entry.playerName1.text = dat[0].name;
		entry.playerName2.text = dat[1].name;
		entry.id = i;
		entry.gotoAndStop(1);
		entry.glowF = glowEntry;
		
		// GOTTA ADD LISTENERS TO ENTRIES AND GOTTA FIX THEM
		if(!Game.playerProgress.hasLockedTeam(team)) {
			entry.addEventListener(MouseEvent.MOUSE_OVER, entryOverHandler);
			entry.addEventListener(MouseEvent.MOUSE_OUT, entryOutHandler);
			entry.addEventListener(MouseEvent.CLICK, clickHandler);			
		}

		// GOTTA ADD
		playerList.addChild(entry);
		entry.mouseChildren = false;
		entry.x = 0;
		entry.y = 16 * counter;
		entries.push(entry);
		
		if(!select && !Game.playerProgress.hasLockedTeam(team)){
			chooseTeam(entry);
			select = true;
		}
		counter++;
	}
}
function chooseTeam(entry) { //team
	chosenTeam = entry.id;
	var dat:Array = Game.dbChar.getTeamCharacterData(chosenTeam);
	Game.chooseTeam(chosenTeam);
	
	// activate entry in middle
	entries[entries.indexOf(entry)].gotoAndStop(2);
	
	unitName1.text = dat[0].name;
	unitName2.text = dat[1].name;
	
	faceIcon1.removeChild(fIcon1);
	faceIcon2.removeChild(fIcon2);
	
	fIcon1 = dat[0].icon;
	fIcon2 = dat[1].icon;
	
	faceIcon1.addChild(fIcon1);
	faceIcon2.addChild(fIcon2);
	
	var frame = playerDisplay1.currentFrame - 1;
	update(playerDisplay1, frame, dat[0]);
	update(playerDisplay2, frame, dat[1]);
}

function startLevel(e) {
	// pressed the start button
	var allTeams:Array	= Game.dbChar.getUnlockedTeams();
	
	//Game.playerProgress.unlockedTeams= new Dictionary();
	
	var team:Array = allTeams[chosenTeam];
	//Game.playerProgress.unlockTeam(team);
	
	//var sound = new se_chargeup();
	//sound.play();
	//SoundManager.playSound("start");
	

	var dat:Array = Game.dbChar.getTeamCharacterData(chosenTeam);
	
	if(Game.playerProgress.health == -1){
		Game.playerProgress.health = dat[0].health;
		dat[1].health = dat[0].health;
	}
	
	clearCharSelect();
	var mdat:MapData = Game.dbMap.getMapData(Game.playerProgress.map);
	//SoundManager.playSong(mdat.bgmusic);	//watch out for this
	
	Game.playerProgress.chosenTeam = team;

	gotoAndStop(1, "game");
		
}

function returnToDifficulty(e) {
	clearCharSelect();
	
	SoundManager.playSound("cancel");

	gotoAndStop("title_screen");
		
}
function charKeyHandler(e) {
	if (e.keyCode == Keyboard.SPACE) {
		startLevel(e);
	}
}

function clearCharSelect() {
	
	beginButton.removeEventListener(MouseEvent.MOUSE_OVER, entryOverHandler);
	beginButton.removeEventListener(MouseEvent.MOUSE_OUT, entryOutHandler);
	beginButton.removeEventListener(MouseEvent.CLICK, startLevel);
	stage.removeEventListener(KeyboardEvent.KEY_DOWN, charKeyHandler);
	
	for (var e in entries) {
		var entry = entries[e];
		entry.removeEventListener(MouseEvent.MOUSE_OVER, entryOverHandler);
		entry.removeEventListener(MouseEvent.MOUSE_OUT, entryOutHandler);
		entry.removeEventListener(MouseEvent.CLICK, clickHandler);
	}
	
	// page buttons
	for (a = 0; a < 2; a++) {
		playerDisplay1["button" + a].removeEventListener(MouseEvent.CLICK, pageHandler);
		playerDisplay2["button" + a].removeEventListener(MouseEvent.CLICK, pageHandler);
	}

	
}

// update display
function update(display:MovieClip, page:Number, char:CharacterData) {
	
	display.gotoAndStop(page + 1);
	
	// update tabs
	for (var a = 0; a < 2; a++) {
		display["button" + a].filters = (page == a) ? [glowDisplay] : [];
	}
	
	//display.setChildIndex(display["button" + page], display.numChildren - 1);
	
	// show correct page
	//display.portrait.visible = (page == 0);
	display.portrait.visible = false;
	display.page4.visible = false;
	display.page2.visible = (page == 0);
	display.page3.visible = (page == 1);
	//display.page4.visible = (page == 3);
	
	// update data inside page
	switch (page) {
		case 0 :
			// show stats
			display.page2.HPCount.text = char.health;
			display.page2.APCount.text = 0;				// TODO: ability power?
			display.page2.SPCount.text = char.speed;
			display.page2.weaponName.text = char.weapon;

			display.page2.wIcon.gotoAndStop(1);
			break;
		case 1 :
			// show AVAILABLE abilities
			//var basicAbilities = AbilityDatabase.getBasicAbilities(ActorDatabase.getName(index));
			
			char.abilities;
			for (var i:int = 0; i < char.abilities.length; i++) {
				var ability:AttackData = char.abilities[i];
				var r = display.page3["row" + i];
				
				r.abilityName.text = ability.name;
				r.description.text = ability.description;
				var ic	= ability.icon;
				ic.x	= 0.25;
				ic.width	= 32;
				ic.height	= 32;
				r.icon.addChild(ic);
			}
			break;
	}
}
function pageHandler(e) {
	// change pages
	var id = e.target.id;
	
	var team:Array = Game.dbChar.getTeamCharacterData(chosenTeam);
	
	update(playerDisplay1, id, team[0]);
	update(playerDisplay2, id, team[1]);
}
function clickHandler(e) {
	// choose entry
	e.target.gotoAndStop(1);
	
	//var sound = new se_timeout();
	//sound.play();
	for(var i = 0; i < entries.length; i++){ 
		entries[i].gotoAndStop(1);
	}
	chooseTeam(entries[entries.indexOf(e.target)]);
}
function entryOverHandler(e) {
	e.target.filters = [e.target.glowF];
}
function entryOutHandler(e) {
	e.target.filters = [];
}