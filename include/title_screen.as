﻿import flash.display.MovieClip;

import game.GameConstants;
import game.SoundManager;
import game.progress.PlayerProgress;

//SoundManager.playSong("Exceed the Sky");

// for button hover glow
var rFilter:GlowFilter = new GlowFilter(0xFF0000, 100, 20, 20, 1, 10, true, false);
var gFilter:GlowFilter = new GlowFilter(0x00FF00, 100, 20, 20, 1, 10, true, false);
var bFilter:GlowFilter = new GlowFilter(0x0000FF, 100, 20, 20, 1, 10, true, false);

var btnFilters:Array	= new Array(bFilter, gFilter, rFilter);
var btnLabels:Array		= new Array("New Game", "Continue");
var btnObjects:Array	= new Array(newGameButton, continueButton);
var btnFuncs:Array		= new Array(newGame, continueGame, config);

for (var a:int = 0; a < btnLabels.length; a++) {
	var b:MovieClip = btnObjects[a];
	b.buttonText.text = btnLabels[a];
	b.mouseChildren = false;
	b.colorFilter	= btnFilters[a];
	b.gotoAndStop(1);
	
	b.addEventListener(MouseEvent.CLICK, btnFuncs[a]);
	b.addEventListener(MouseEvent.MOUSE_OVER, overHandler);
	b.addEventListener(MouseEvent.MOUSE_OUT, outHandler);
}

function newGame(e:Event):void {
	//var sound:Sound = new se_chargeup();
	//sound.play();
	SoundManager.playSound("select");
	
	clearTitleScreen();
	Game.playerProgress.newGame();
	
	if(GameConstants.BEGIN_CHAR_SELECT) {
		gotoAndStop("char_select2"); //FIX TODO		
	} else {
		Game.charID = "GK1";
		
		Game.playerProgress.gameMode = PlayerProgress.FREETIME_MODE;
		
		gotoAndStop(1, "game");
	}
}

function continueGame(e:Event):void {
	///var sound:Sound = new se_chargeup();
	//sound.play();
	SoundManager.playSound("select");
	
	clearTitleScreen();
	Game.playerProgress.loadGame("PERKINITES");
	gotoAndStop("char_select2");
}

function config(e:Event):void {
	//var sound:Sound = new se_timeout();
	//sound.play();
	
	clearTitleScreen();
	gotoAndStop("char_select2");
}

function clearTitleScreen() {
	for (var a = 0; a < btnLabels.length; a++) {
		var b = btnObjects[a];
		b.removeEventListener(MouseEvent.CLICK, btnFuncs[a]);
		b.removeEventListener(MouseEvent.MOUSE_OVER, overHandler);
		b.removeEventListener(MouseEvent.MOUSE_OUT, outHandler);
	}
}

function overHandler(e:Event):void {
	e.target.filters = [e.target.colorFilter];
}

function outHandler(e:Event):void {
	e.target.filters = [];
}