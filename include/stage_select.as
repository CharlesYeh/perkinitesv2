
var unlockedLevels = 1;

var level = 1;
var diff = 0;
var Ananya = false;

// set up stage data
var stageArray = new Array("Perkins Hall", "Josiah's", "Sharpe Refectory", "Watson Center (CIT)", "Sciences Library", "Faunce House", "???");
var difficultyArray = new Array([1, 4, 7, 9],
								[2, 5, 8, 11],
								[3, 6, 9, 12],
								[4, 7, 11, 14],
								[5, 8, 12, 15],
								[6, 9, 14, 16],
								[7, 10, 15, 18]);

// initialize level markers
var areaMarkers = new Array(map.perkins, map.josiah, map.ratty, map.cit, map.scili, map.xx, map.yy);

for (var i = 0; i < areaMarkers.length; i++) {
	var m = areaMarkers[i];
	if (i < unlockedLevels) {
		// level is playable
		m.stageNumber = i + 1;
		m.mouseChildren = false;
		m.addEventListener(MouseEvent.MOUSE_DOWN, setStageHandler);
	}
	else {
		// level is unlocked
		m.visible=false;
	}
}

difficultyIcon.gotoAndStop(1);

updateDifficulty(level, diff);
updateText(level);

addEventListener(MouseEvent.MOUSE_DOWN, dragMap);
addEventListener(MouseEvent.MOUSE_UP, releaseMap);
stage.addEventListener(KeyboardEvent.KEY_DOWN, keyHandler);
stage.addEventListener(Event.MOUSE_LEAVE, releaseMap);

function setStageHandler(e) {
	var obj = e.target;
	level = obj.stageNumber;

	updateText(level);
	updateDifficulty(level, diff);
}
// difficulty changing, and back/continue
function keyHandler(e:KeyboardEvent):void {
	var sound;
	
	if (e.keyCode == Keyboard.DOWN || e.keyCode == "S".charCodeAt(0)) {
		// change difficulty
		diff = (++diff) % (Ananya ? 4 : 3);
		updateDifficulty(level, diff);
		
		sound = new se_timeout();
		sound.play();
	} else if (e.keyCode == Keyboard.UP || e.keyCode == "W".charCodeAt(0)) {
		// change difficulty
		diff--;
		if (diff < 0) {
			diff = (Ananya) ? 3 : 2;
		}
		updateDifficulty(level, diff);
		
		sound = new se_timeout();
		sound.play();
	} else if (e.keyCode == "X".charCodeAt(0)) {
		// back to title screen
		sound = new se_timeout();
		sound.play();
		
		clearStageSelect();
		gotoAndStop("title_screen");
	} else if (e.keyCode == Keyboard.SPACE) {
		// choose stage
		sound = new se_chargeup();
		sound.play();
		
		clearStageSelect();
		gotoAndStop("char_select");
	}
}

// level: 1+, diff: 0+
function updateDifficulty(level:Number, diff:Number) {
	difficultyIcon.gotoAndStop(diff + 1);
	difficultyIcon.diffLevel.text = (difficultyArray[level - 1][diff] > 15)
									? "!!!!" : difficultyArray[level - 1][diff];
	
	switch (diff) {
	case 0 :
		difficultyDescription.text = "Units deal 1.5x damage.\n\nEnemies deal 1x damage.\n\nEnemies are average.";
		break;
	case 1 :
		difficultyDescription.text = "Units deal 1x damage.\n\nEnemies deal 1x damage.\n\nEnemies are tricky.";
		break;
	case 2 :
		difficultyDescription.text = "Units deal 1x damage.\n\nEnemies deal 2x damage.\n\nEnemies are advanced.";
		break;
	case 3 :
		difficultyDescription.text = "Units deal 1x damage.\n\nEnemies deal 3x damage.\n\nEnemies take after Ananya. AKA, they will f**king destroy you.";
		break;
	}
}

// update bottom descriptions
function updateText(level:Number) {
	stageNumber.text= level + "" ;
	stageName.text	= stageArray[level - 1];
}
function dragMap(e) {
	map.startDrag(false, new Rectangle(-370, -610, 150, 500));
}
function releaseMap(e) {
	map.stopDrag();
	stage.focus = null;
}
function clearStageSelect() {
	removeEventListener(MouseEvent.MOUSE_DOWN, dragMap);
	removeEventListener(MouseEvent.MOUSE_UP, releaseMap);
	stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyHandler);
	stage.removeEventListener(Event.MOUSE_LEAVE, releaseMap);
	
	for (var i = 0; i < areaMarkers.length; i++) {
		if (i < unlockedLevels)
			areaMarkers[i].removeEventListener(MouseEvent.MOUSE_DOWN, setStageHandler);
	}
}
