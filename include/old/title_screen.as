/*
// for button hover glow
var rFilter = new GlowFilter(0xFF0000, 100, 20, 20, 1, 10, true, false);
var gFilter = new GlowFilter(0x00FF00, 100, 20, 20, 1, 10, true, false);
var bFilter = new GlowFilter(0x0000FF, 100, 20, 20, 1, 10, true, false);

var btnFilters	= new Array(bFilter, gFilter, rFilter);
var btnLabels	= new Array("New Game", "Continue", "Settings");
var btnObjects	= new Array(newGameButton, continueButton, configButton);
var btnFuncs	= new Array(newGame, continueGame, config);


for (var a = 0; a < btnLabels.length; a++) {
	var b = btnObjects[a];
	b.buttonText.text = btnLabels[a];
	b.mouseChildren = false;
	b.colorFilter	= btnFilters[a];
	b.gotoAndStop(1);
	
	b.addEventListener(MouseEvent.CLICK, btnFuncs[a]);
	b.addEventListener(MouseEvent.MOUSE_OVER, overHandler);
	b.addEventListener(MouseEvent.MOUSE_OUT, outHandler);
}

function newGame(e:Event):void {
	var sound = new se_chargeup();
	sound.play();
	
	clearTitleScreen();
	gotoAndStop("stage_select");
}
function continueGame(e:Event):void {
	var sound = new se_chargeup();
	sound.play();
	
	clearTitleScreen();
	gotoAndStop("stage_select");
}
function config(e:Event):void {
	var sound = new se_timeout();
	sound.play();
	
	clearTitleScreen();
	gotoAndStop("stage_select");
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
}*/