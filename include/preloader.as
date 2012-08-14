import flash.external.ExternalInterface;

/*ActorDatabase.loadXML("_xml/Actors.xml");
EnemyDatabase.loadXML("_xml/Enemies.xml");
MapDatabase.loadXML("_xml/Tilesets.xml", "_xml/Maps.xml");*/

if (ExternalInterface.available) {
	ExternalInterface.addCallback("rightClicked", rightClicked);
}

function rightClicked(x:int, y:int) {
	trace(x, y);
}
