﻿/*import util.KeyDown;
//import game.MapManager;
import game.GameUnit;
import game.AIUnit;
import game.Perkinite;
import game.NPCUnit;
import tileMapper.ScreenRect;
import flash.ui.Keyboard;
import flash.geom.Point;
import db.*;
import flash.display.MovieClip;

var player = new Perkinite(chosenTeam);
var partner= new Perkinite(chosenTeam + 1);

player.setPartner(partner);
partner.setPartner(player);

var gamePause = false;
var mouseCasting = false;

hud.updateIcons(chosenTeam, chosenTeam + 1);

addEventListener(Event.ENTER_FRAME, gameRunnerHandler);
addEventListener(MouseEvent.MOUSE_DOWN, gameClickHandler);



init(0, new Point(62, 10));

function init(map:int, startPoint:Point) {
	// setup map
	addChild(MapManager.mapClip);
	this.setChildIndex(hud, numChildren - 1);
	MapManager.loadMap(map, player, partner);
	MapManager.addToMapClip(player);
	MapManager.addToMapClip(partner);
	
	//MapManager.setHeroPosition(player, partner, startPoint);
	//fixing to make sure they don't infinite run into teleport point
	player.path = new Array();
	partner.path = new Array();
}
function clearMap() {
	MapManager.clearTelePoints();
	MapManager.clearAIUnits();
	MapManager.clearNPCUnits();
	MapManager.removeFromMapClip(player);
	MapManager.removeFromMapClip(partner);
}
function gameRunnerHandler(e) {
	
	// update hud
	hud.showCooldowns(player, partner);

	if(NPCUnit.pauseActions)
		return;
		
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
	
	Controls.handleKeyboard(new Array(player, partner));
}
*/