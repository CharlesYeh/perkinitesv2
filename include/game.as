import util.KeyDown;
import game.MapManager;
import game.GameUnit;
import game.AIUnit;
import game.Perkinite;
import tileMapper.ScreenRect;
import flash.ui.Keyboard;
import flash.geom.Point;
import db.*;
import flash.display.MovieClip;

KeyDown.init(stage);

var player = new Perkinite(chosenTeam);
var partner= new Perkinite(chosenTeam + 1);

player.setPartner(partner);
partner.setPartner(player);

var gamePause = false;
var mouseCasting = false;

AIUnit.setTargets(new Array(player, partner));
hud.updateIcons(chosenTeam, chosenTeam + 1);

addEventListener(Event.ENTER_FRAME, gameRunnerHandler);
addEventListener(MouseEvent.MOUSE_DOWN, gameClickHandler);
stage.addEventListener(Event.DEACTIVATE, loseFocus);
pauseScreen.addEventListener(MouseEvent.CLICK, regainFocus);

pauseScreen.y = 999;

function loseFocus(e) {
	gamePause = true;
	pauseScreen.y = 0;
}
function regainFocus(e) {
	gamePause = false;
	pauseScreen.y = 999;
}

init(0, new Point(15, 10));

function init(map:int, startPoint:Point) {
	// setup map
	addChild(MapManager.mapClip);
	this.setChildIndex(hud, numChildren - 1);
	MapManager.loadMap(map, player, partner);
	MapManager.addToMapClip(player);
	MapManager.addToMapClip(partner);
	
	// create enemies?
	MapManager.createEnemy(0, 1500, 400);
	MapManager.createEnemy(1, 1500, 400);
	MapManager.createEnemy(2, 1500, 400);
	
	MapManager.setHeroPosition(player, partner, startPoint);
}
function clearMap() {
	MapManager.clearAIUnits();
	MapManager.removeFromMapClip(player);
	MapManager.removeFromMapClip(partner);
}
function gameRunnerHandler(e) {
	
	// update hud
	hud.showCooldowns(player, partner);
	
	// handle casting
	var mpos:Point = new Point(getMouseX(), getMouseY());
	
	if (KeyDown.keyIsDown(Keyboard.A)) {
		player.castAbility(0, mpos);
	}
	if (KeyDown.keyIsDown(Keyboard.S)) {
		player.castAbility(1, mpos);
	}
	if (KeyDown.keyIsDown(Keyboard.D)) {
		partner.castAbility(0, mpos);
	}
	if (KeyDown.keyIsDown(Keyboard.F)) {
		partner.castAbility(1, mpos);
	}
	
	// show aim guides
	var mPoint = new Point(getMouseX(), getMouseY());
	
	player.mouseHandler(mPoint);
	partner.mouseHandler(mPoint);
	
	// movement
	if (KeyDown.keyIsDown(KeyDown.MOUSE) && !mouseCasting) {
		player.moveTo(getMouseX(), getMouseY());
		partner.moveTo(getMouseX(), getMouseY());
	}
	
	// test inter-map movement
	var tp:MovieClip = MapManager.testTeleportPoints(player);
	if (tp != null) {
		clearMap();
		init(tp.destMap, tp.destPoint);
	}
}
function getMouseX() {	return mouseX + ScreenRect.getX();	}
function getMouseY() {	return mouseY + ScreenRect.getY();	}
function gameClickHandler(e) {
	var mPoint = new Point(getMouseX(), getMouseY());
	
	var target = null;
	var aiUnits = MapManager.getAIUnits();
	for (var a in aiUnits) {
		if (aiUnits[a].inRadius(100, mPoint)) {
			target = aiUnits[a];
			break;
		}
	}
	
	// make sure both are run, don't short circuit
	if (player.clickHandler(mPoint, target) | partner.clickHandler(mPoint, target)) {
		// this mouse down was for cast
		mouseCasting = true;
	}
	else {
		mouseCasting = false;
	}
}
