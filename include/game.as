import game.Game;

stop();

stage.addEventListener(Event.DEACTIVATE, loseFocus);
pauseScreen.addEventListener(MouseEvent.CLICK, regainFocus);
pauseScreen.y = 999;

var gamePause:Boolean = true;

//AIUnit.setTargets(new Array(player, partner));
Game.dbChar.getTeamCharacterData(chosenTeam);

function loseFocus(e) {
	gamePause = true;
	pauseScreen.y = 0;
}

function regainFocus(e) {
	gamePause = false;
	pauseScreen.y = 999;
}