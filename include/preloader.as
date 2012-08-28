import flash.external.ExternalInterface;

import game.Game;
import game.Controls;

import db.AbilityDatabase;

import util.KeyDown;

KeyDown.init(stage);
Controls.setupRightClick();
Game.init();
trace(ExternalInterface.available);

Security.allowDomain("eactiv.com");
Security.allowDomain("localhost");

// TODO: preloader
