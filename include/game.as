import game.Game;
import game.Controls;
import ui.*;
import flash.display.MovieClip;
import util.KeyDown;

stop();

Game.startGameWorld(this);
this.mouseChildren = true;
setupGame();

function gameRunner(e:Event):void {
	Game.update();
}

function setupGame():void {
	
	addEventListener(Event.ENTER_FRAME, gameRunner);
	stage.addEventListener(Event.DEACTIVATE, loseFocus);
	
}

function clearGame():void {
	removeEventListener(Event.ENTER_FRAME, gameRunner);
	stage.removeEventListener(Event.DEACTIVATE, loseFocus);
	pauseScreen.removeEventListener(MouseEvent.CLICK, regainFocus);
}

function loseFocus(e:Event) {
	Game.gamePause = true;
	var f = new FocusScreen();
	stage.addChild(f);
	f.addEventListener(MouseEvent.CLICK, regainFocus);
	f.addEventListener("rightMouseDown", regainFocus);
	//Controls.enabled = false;
	KeyDown.clearBindings();
	
	//pauseScreen.y = 0;
}

function regainFocus(e:MouseEvent):void {
	Game.gamePause = false;
	e.target.parent.removeChild(e.target);
	//Controls.enabled = true;
	//KeyDown.clearBindings();
	//pauseScreen.y = 999;
}