import db.*;

import game.Game;

import game.SoundManager;

import flash.display.MovieClip;
import flash.display.Loader;

var glowEntry2 = new GlowFilter(0xFFFFFF, 100, 20, 20, 1, 10, false, false);
var glowBegin2 = new GlowFilter(0xFF9900, 100, 20, 20, 1, 10, true, false);

basic.difficulty = 0;
maniac.difficulty = 1;
demonic.difficulty = 2;

basic.difficultyIcon.gotoAndStop(basic.difficulty+1);
maniac.difficultyIcon.gotoAndStop(maniac.difficulty+1);
demonic.difficultyIcon.gotoAndStop(demonic.difficulty+1);
//ananya.difficulty = 3;

basic.addEventListener(MouseEvent.MOUSE_OVER, entryOverHandler3);
basic.addEventListener(MouseEvent.MOUSE_OUT, entryOutHandler2);
basic.addEventListener(MouseEvent.CLICK, selectDifficulty);

maniac.addEventListener(MouseEvent.MOUSE_OVER, entryOverHandler3);
maniac.addEventListener(MouseEvent.MOUSE_OUT, entryOutHandler2);
maniac.addEventListener(MouseEvent.CLICK, selectDifficulty);

demonic.addEventListener(MouseEvent.MOUSE_OVER, entryOverHandler3);
demonic.addEventListener(MouseEvent.MOUSE_OUT, entryOutHandler2);
demonic.addEventListener(MouseEvent.CLICK, selectDifficulty);

basic.mouseChildren = false;
maniac.mouseChildren = false;
demonic.mouseChildren = false;

backButton.buttonText.text = "<- Back";
backButton.mouseChildren = false;
backButton.glowF = glowBegin2;

backButton.addEventListener(MouseEvent.MOUSE_OVER, entryOverHandler2);
backButton.addEventListener(MouseEvent.MOUSE_OUT, entryOutHandler2);
backButton.addEventListener(MouseEvent.CLICK, returnToMain);


function selectDifficulty(e) {
	// pressed the start button
	Game.playerProgress.difficulty = e.target.difficulty;
	
	SoundManager.playSound("select");
	
	gotoAndStop("char_select");
		
}

function returnToMain(e) {
	
	SoundManager.playSound("cancel");

	gotoAndStop("title_screen");
		
}


function entryOverHandler2(e) {
	e.target.filters = [e.target.glowF];
}
function entryOverHandler3(e) {
	e.target.filters = [glowEntry2];
}
function entryOutHandler2(e) {
	e.target.filters = [];
}