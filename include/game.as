import game.Game;
import game.Controls;

stop();

stage.addEventListener(Event.DEACTIVATE, loseFocus);
pauseScreen.addEventListener(MouseEvent.CLICK, regainFocus);
pauseScreen.y = 999;

Game.startGameWorld(this);

//AIUnit.setTargets(new Array(player, partner));
Game.dbChar.getTeamCharacterData(chosenTeam);

function gameRunnerHandler(e:Event):void {
	Controls.handleGameInputs();
}

function loseFocus(e:Event) {
	Game.gamePause = true;
	pauseScreen.y = 0;
}

function regainFocus(e:MouseEvent):void {
	Game.gamePause = false;
	pauseScreen.y = 999;
}