import util.KeyDown;
import game.MapManager;
import game.GameUnit;
import game.AIUnit;
import game.Perkinite;
import tileMapper.ScreenRect;
import flash.ui.Keyboard;
import flash.geom.Point;
import db.*;

KeyDown.init(stage);

/*var player = new GameUnit();
var partner= new GameUnit();*/

var player = new Perkinite(chosenTeam);
var partner= new Perkinite(chosenTeam + 1);

var aiUnits = new Array();

AIUnit.setTargets(new Array(player, partner));

// setup map
addChild(MapManager.mapClip);
MapManager.loadMap(0, player, partner);
MapManager.addToMapClip(player);
MapManager.addToMapClip(partner);

addEventListener(Event.ENTER_FRAME, gameRunnerHandler);
addEventListener(MouseEvent.CLICK, gameClickHandler);

init();

function init() {
	MapManager.setHeroPosition(player, partner);
	
	// create enemies?
	createEnemy(0, 1500, 400);
}
function createEnemy(id:int, ox, oy) {
	var u = new AIUnit(id);
	u.x = ox;
	u.y = oy;
	MapManager.addToMapClip(u);
	aiUnits.push(u);
}
function gameRunnerHandler(e) {
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
	if (KeyDown.keyIsDown(KeyDown.MOUSE)) {
		player.moveTo(getMouseX(), getMouseY());
		partner.moveTo(getMouseX(), getMouseY());
	}
}
function getMouseX() {
	return mouseX + ScreenRect.getX();
}
function getMouseY() {
	return mouseY + ScreenRect.getY();
}
function gameClickHandler(e) {
	var mPoint = new Point(getMouseX(), getMouseY());
	
	var target = null;
	for (var a in aiUnits) {
		if (aiUnits[a].inRadius(100, mPoint)) {
			target = aiUnits[a];
			break;
		}
	}
	
	player.clickHandler(mPoint, target);
	partner.clickHandler(mPoint, target);
}
