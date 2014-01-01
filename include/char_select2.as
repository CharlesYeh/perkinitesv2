import db.*;

import db.dbData.CharacterData;
import db.dbData.AttackData;
import db.dbData.MapData;
import game.Game;

import game.SoundManager;
import game.progress.PlayerProgress;

import flash.display.MovieClip;
import flash.display.Loader;
import flash.display.Bitmap;

var fIcon1:Loader = new Loader();
faceIcon1.addChild(fIcon1);

var entries:Array = new Array();
var chosenID:String = "";

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

// show available teams in middle
showEntries();

function showEntries() {
	var allChars:Array = Game.dbChar.getAllCharacters();
	
	var select = false;
	for (var i = 0; i < allChars.length - 2; i++) {
		var entry = new FaceIcon();
		var loader = new Loader();
		loader = allChars[i+2].icon;
		entry.glowF = glowEntry;
		entry.addChild(loader);
		playerList.addChild(entry);
		entry.mouseChildren = false;
		entry.id = allChars[i+2].id;
		entry.x = (64 + 4) * (i % 6) + 8 ;
		entry.y = (64 + 4) * Math.floor(i / 6) + 8;
		entry.width = 64;
		entry.height = 64;
		
		entry.addEventListener(MouseEvent.MOUSE_OVER, entryOverHandler);
		entry.addEventListener(MouseEvent.MOUSE_OUT, entryOutHandler);
		entry.addEventListener(MouseEvent.CLICK, clickHandler);			
	
		entries.push(entry);
		
		if(!select){
			choose(allChars[i+2].id);
			select = true;
		}
	}
}
function choose(id) { //team
	chosenID = id;
	var dat:CharacterData = Game.dbChar.getCharacterData(id);
	//Game.chooseTeam(chosenTeam);
	
	// activate entry in middle
	//entries[entries.indexOf(entry)].gotoAndStop(2);
	
	unitName1.text = dat.name;
	subtitle.text = dat.weapon;
	if(fIcon1.parent == faceIcon1) {
		faceIcon1.removeChild(fIcon1);
	}
	
	var clonedData = Bitmap(dat.icon.content).bitmapData.clone();
	
	faceIcon1.addChild(new Bitmap(clonedData));
	
	var frame = playerDisplay1.currentFrame - 1;
	update(playerDisplay1, frame, dat);
}

function startLevel(e) {
	// pressed the start button
	
	//Game.playerProgress.unlockedTeams= new Dictionary();
	//Game.playerProgress.unlockTeam(team);
	
	//var sound = new se_chargeup();
	//sound.play();
	//SoundManager.playSound("start");
	
	Game.charID = chosenID;
	
	Game.playerProgress.gameMode = PlayerProgress.CAMPAIGN_MODE;

	var dat:CharacterData = Game.dbChar.getCharacterData(chosenID);
	
	clearCharSelect();
	var mdat:MapData = Game.dbMap.getMapData(Game.playerProgress.map);
	//SoundManager.playSong(mdat.bgmusic);	//watch out for this
	
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
}

// update display
function update(display:MovieClip, page:Number, char:CharacterData) {
	
	display.gotoAndStop(page + 1);
	
	display.page2.APCount.text = char.defense;
	display.page2.DPCount.text = char.defense;		
	display.page2.SPCount.text = char.speed;
	
	for (var i:int = 0; i < char.abilities.length; i++) {
		var ability:AttackData = char.abilities[i];
		var r = display.page2["row" + i];
		
		r.abilityName.text = ability.name;
		r.description.text = ability.description;
		var ic	= ability.icon;
		ic.x	= 0.25;
		ic.width	= 32;
		ic.height	= 32;
		r.icon.addChild(ic);
	}	
}

function clickHandler(e) {
	var name = entries[entries.indexOf(e.target)].id;
	
	//var sound = new se_timeout();
	//sound.play();
	
	var allChars:Array = Game.dbChar.getAllCharacters();
	
	// must only show available Units, not all Units!
	
	for(var i = 0; i < entries.length; i++){ 
		entries[i].parent.removeChild(entries[i]);
	}
	
	entries = new Array();
	for (var i = 0; i < allChars.length - 2; i++) {
		var entry = new FaceIcon();
		var loader = new Loader();
		loader = allChars[i+2].icon;
		entry.glowF = glowEntry;
		entry.addChild(loader);
		playerList.addChild(entry);
		entry.mouseChildren = false;
		entry.id = allChars[i+2].id;
		entry.x = (64 + 4) * (i % 6) + 8 ;
		entry.y = (64 + 4) * Math.floor(i / 6) + 8;
		entry.width = 64;
		entry.height = 64;
		
		entry.addEventListener(MouseEvent.MOUSE_OVER, entryOverHandler);
		entry.addEventListener(MouseEvent.MOUSE_OUT, entryOutHandler);
		entry.addEventListener(MouseEvent.CLICK, clickHandler);			
	
		entries.push(entry);
	}
	
	choose(name);
}
function entryOverHandler(e) {
	e.target.filters = [e.target.glowF];
}
function entryOutHandler(e) {
	e.target.filters = [];
}