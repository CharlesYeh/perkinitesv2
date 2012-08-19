import flash.external.ExternalInterface;
import game.Game;
import db.AbilityDatabase;

Game.init();

Security.allowDomain("eactiv.com");
Security.allowDomain("localhost");

if (ExternalInterface.available) {
	ExternalInterface.addCallback("rightClicked", rightClicked);
}

function rightClicked(x:int, y:int) {
	trace(x, y);
}
