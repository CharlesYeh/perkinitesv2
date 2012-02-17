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

AIUnit.setTargets(new Array(player, partner));

// setup map
addChild(MapManager.mapClip);
MapManager.loadMap(0, player, partner);
MapManager.addToMapClip(player);
MapManager.addToMapClip(partner);

addEventListener(Event.ENTER_FRAME, gameRunnerHandler);

init();

function init() {
	MapManager.setHeroPosition(player, partner);
	
	// create enemies?
	createEnemy(0);
}
function createEnemy(id:int) {
	var u = new AIUnit(id);
	u.x = 1500;
	u.y = 400;
	MapManager.addToMapClip(u);
}
function gameRunnerHandler(e) {
	if (KeyDown.keyIsDown(KeyDown.MOUSE)) {
		player.moveTo(mouseX + ScreenRect.getX(), mouseY + ScreenRect.getY());
		partner.moveTo(mouseX + ScreenRect.getX(), mouseY + ScreenRect.getY());
	}
	
	var mpos:Point = new Point(mouseX, mouseY);
	
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
	
}
