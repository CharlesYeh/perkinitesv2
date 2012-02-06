import db.*;
import flash.display.MovieClip;

faceIcon1.gotoAndStop(1);
faceIcon2.gotoAndStop(1);			

var entries = new Array();
var chosenTeam = 0;

scrollPane.source = playerList;

var glowDisplay=new GlowFilter(0xFF9900, 100, 20, 20, 1, 5, true, false);
var glowEntry = new GlowFilter(0xFFFFFF, 100, 20, 20, 1, 10, true, false);
var glowBegin = new GlowFilter(0xFF9900, 100, 20, 20, 1, 10, true, false);

beginButton.buttonText.text = "Start!";
beginButton.mouseChildren = false;
beginButton.glowF = glowBegin;

beginButton.addEventListener(MouseEvent.MOUSE_OVER, entryOverHandler);
beginButton.addEventListener(MouseEvent.MOUSE_OUT, entryOutHandler);
beginButton.addEventListener(MouseEvent.CLICK, startLevel);
stage.addEventListener(KeyboardEvent.KEY_DOWN, charKeyHandler);

for (a = 0; a <= 3; a++) {
	var b1 = playerDisplay1["button" + a];
	var b2 = playerDisplay2["button" + a];
	
	b1.mouseChildren = false;
	b2.mouseChildren = false;
	b1.id = a;
	b2.id = a;
	
	b1.addEventListener(MouseEvent.CLICK, pageHandler);
	b2.addEventListener(MouseEvent.CLICK, pageHandler);
}

// show available teams in middle
showEntries();
chooseTeam(0);

function showEntries() {
	var names	= ActorDatabase.getUnlockedNames();
	
	// Must only show available Units, not all Units!
	for (var i = 0; i < names.length; i += 2) {
		var entry = new Entry();
		entry.playerName1.text = names[i];
		entry.playerName2.text = names[i + 1];
		entry.id = i;
		entry.gotoAndStop(1);
		entry.glowF = glowEntry;
		
		// GOTTA ADD LISTENERS TO ENTRIES AND GOTTA FIX THEM
		entry.addEventListener(MouseEvent.MOUSE_OVER, entryOverHandler);
		entry.addEventListener(MouseEvent.MOUSE_OUT, entryOutHandler);
		entry.addEventListener(MouseEvent.CLICK, clickHandler);

		// GOTTA ADD
		playerList.addChild(entry);
		entry.mouseChildren = false;
		entry.x = 0;
		entry.y = 8 * i;
		entries.push(entry);
	}
}
function chooseTeam(team) {
	chosenTeam = team;
	// activate entry in middle
	entries[(chosenTeam >> 1)].gotoAndStop(2);
	
	unitName1.text = ActorDatabase.getName(chosenTeam);
	unitName2.text = ActorDatabase.getName(chosenTeam + 1);
	
	faceIcon1.gotoAndStop(chosenTeam + 1);
	faceIcon2.gotoAndStop(chosenTeam + 2);
	
	update(playerDisplay1, 0, chosenTeam);
	update(playerDisplay2, 0, chosenTeam + 1);
}

function startLevel(e) {
	// pressed the start button
	var sound = new se_chargeup();
	sound.play();
	
	clearCharSelect();
	gotoAndStop(1, "game");
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
	stage.addEventListener(KeyboardEvent.KEY_DOWN, charKeyHandler);
	
	for (var e in entries) {
		var entry = entries[e];
		entry.removeEventListener(MouseEvent.MOUSE_OVER, entryOverHandler);
		entry.removeEventListener(MouseEvent.MOUSE_OUT, entryOutHandler);
		entry.removeEventListener(MouseEvent.CLICK, clickHandler);
	}
	
	// page buttons
	for (a = 0; a < 4; a++) {
		playerDisplay1["button" + a].removeEventListener(MouseEvent.CLICK, pageHandler);
		playerDisplay2["button" + a].removeEventListener(MouseEvent.CLICK, pageHandler);
	}
}

// update display
function update(display:MovieClip, page:Number, index:Number) {
	display.gotoAndStop(page);
	
	// update tabs
	for (var a = 0; a < 4; a++) {
		display["button" + a].filters = (page == a) ? [glowDisplay] : [];
	}
	
	//display.setChildIndex(display["button" + page], display.numChildren - 1);
	
	// show correct page
	display.portrait.visible = (page == 0);
	display.page2.visible = (page == 1);
	display.page3.visible = (page == 2);
	display.page4.visible = (page == 3);
	
	// update data inside page
	switch (currentFrame) {
		case 0 :
			display.portrait.gotoAndStop(index + 1);
			break;
		case 1 :
			// show stats
			display.page2.HPCount.text = ActorDatabase.getHP(index) + "";
			display.page2.APCount.text = ActorDatabase.getDmg(index) + "";
			display.page2.SPCount.text = ActorDatabase.getSpeed(index) + "";
			display.page2.weaponName.text = ActorDatabase.getWeapon(index);

			display.page2.wIcon.gotoAndStop(index + 1);
			break;
		case 2 :
			// show AVAILABLE abilities
			/*var basicAbilities = AbilityDatabase.getBasicAbilities(ActorDatabase.getName(index));

			for (var i = 0; i < icons.length; i++) {
				if (i < basicAbilities.length) {
					icons[i].useCount.visible = false;
					icons[i].visible = true;
					names[i].visible = true;
					descriptions[i].visible = true;
					icons[i].gotoAndStop(basicAbilities[i].index);
					names[i].text = basicAbilities[i].Name;
					descriptions[i].text = basicAbilities[i].getSpecInfo();
					icons[i].gotoAndStop(basicAbilities[i].index);
				} else {
					break;
				}
			}

			// hide advanced abilities
			for (i; i < icons.length; i++) {
				icons[i].gotoAndStop(1);
				icons[i].useCount.visible = false;
				icons[i].visible = false;
				names[i].visible = false;
				descriptions[i].visible = false;
			}*/
			break;
		case 3 :
			/*page4.ffName.text=ActorDatabase.getFFName(index);
			page4.ffDescription.text=ActorDatabase.getFFDescription(index);
			page4.ffBonus.text=ActorDatabase.getFFBonus(index);

			page4.ffIcon.gotoAndStop(Math.ceil((index+1)/2));*/
			display.page4.ffIcon.gotoAndStop(1);
			break;
	}
}
function pageHandler(e) {
	// change pages
	var id = e.target.id;
	
	update(playerDisplay1, id, chosenTeam);
	update(playerDisplay2, id, chosenTeam + 1);
}
function clickHandler(e) {
	// choose entry
	entries[(chosenTeam >> 1)].gotoAndStop(1);
	
	var sound = new se_timeout();
	sound.play();
	
	chooseTeam(e.target.id);
}
function entryOverHandler(e) {
	e.target.filters = [e.target.glowF];
}
function entryOutHandler(e) {
	e.target.filters = [];
}