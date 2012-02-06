import util.KeyDown;
import game.MapManager;
import game.GameUnit;
import tileMapper.ScreenRect;
import flash.ui.Keyboard;

KeyDown.init(stage);

var player = new GameUnit();
var partner= new GameUnit();

// setup map
addChild(MapManager.mapClip);
MapManager.loadMap(0, player, partner);
MapManager.addToMapClip(player);
MapManager.addToMapClip(partner);

addEventListener(MouseEvent.CLICK, gameMoverHandler);

init();

function init() {
	MapManager.setHeroPosition(player, partner);
}
function gameMoverHandler(e) {
	player.moveTo(mouseX + ScreenRect.getX(), mouseY + ScreenRect.getY());
	partner.moveTo(mouseX + ScreenRect.getX(), mouseY + ScreenRect.getY());
}
