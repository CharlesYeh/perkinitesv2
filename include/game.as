import game.Game;
import game.Controls;

stop();

setupGame();
Game.startGameWorld(this);

function gameRunner(e:Event):void {
	Game.update();
}

function setupGame():void {
	addEventListener(Event.ENTER_FRAME, gameRunner);
	stage.addEventListener(Event.DEACTIVATE, loseFocus);
	pauseScreen.addEventListener(MouseEvent.CLICK, regainFocus);
	
	pauseScreen.y = 999;
}

function clearGame():void {
	removeEventListener(Event.ENTER_FRAME, gameRunner);
	stage.removeEventListener(Event.DEACTIVATE, loseFocus);
	pauseScreen.removeEventListener(MouseEvent.CLICK, regainFocus);
}

function loseFocus(e:Event) {
	Game.gamePause = true;
	pauseScreen.y = 0;
}

function regainFocus(e:MouseEvent):void {
	Game.gamePause = false;
	pauseScreen.y = 999;
}