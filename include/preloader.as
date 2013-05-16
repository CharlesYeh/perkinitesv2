import flash.external.ExternalInterface;
import flash.events.MouseEvent;

import game.Game;
import game.Controls;

import db.AbilityDatabase;

import util.KeyDown;
import flash.events.Event;

KeyDown.init(stage);
//Controls.setupRightClick();
Game.init();

Security.allowDomain("eactiv.com");
Security.allowDomain("localhost");

// TODO: preloader
