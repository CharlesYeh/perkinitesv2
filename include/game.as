import util.KeyDown;
import game.MapManager;
import game.GameUnit;

KeyDown.init(stage);

var player = new GameUnit();

// setup map
addChild(MapManager.mapClip);
MapManager.loadMap(0, player);

