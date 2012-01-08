import util.KeyDown;
import game.MapManager;

KeyDown.init(stage);

// setup map
addChild(MapManager.mapClip);
MapManager.stageRef = stage;
MapManager.loadMap(0);

