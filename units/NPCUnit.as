package units {
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.display.MovieClip;
	import flash.geom.Point;
	
	import tileMapper.TileMap;
	import db.AbilityDatabase;
	import db.dbData.MapCharacterData;
	import attacks.Attack;
	
	import game.GameConstants;
	import game.progress.CharacterProgress;

	public class NPCUnit extends StatUnit {
		
		public var mapCharacterData:MapCharacterData;
				
		public function NPCUnit(mcdat:MapCharacterData) {
			super(null);
			
			mapCharacterData = mcdat;
			// load swf
			loadSwf();
		}
		
		override protected function loadSwf() {
			swf = new Loader();
			swf.load(getSprite());
			addChild(swf);
			
			swf.contentLoaderInfo.addEventListener(Event.COMPLETE, completeLoad);
		}		
		override protected function getSprite():URLRequest {
			return new URLRequest(GameConstants.PATH_SPRITES + mapCharacterData.id + GameConstants.SPRITES_EXT);
		}		
		override function completeLoad(e):void {
			loaded = true;
			
			swf.content.char.stop();
			swf.content.char.dire.gotoAndStop(ANIM_STANDING);
			swf.content.char.dirn.gotoAndStop(ANIM_STANDING);
			swf.content.char.dirs.gotoAndStop(ANIM_STANDING);
			setAnimLabel(ANIM_STANDING);
			trace(mapCharacterData.direction);
			switch(mapCharacterData.direction){
				case "right":
					updateDirection(0);
					break;
				case "up":
					updateDirection(1);
					break;
				case "left":
					updateDirection(2);
					break;
				case "down":
					updateDirection(3);
					trace("down");
					break;
			}
			
			swf.content.char.endAbility			= endAbility;
			swf.content.char.disableMovement	= disableMovement;
			swf.content.char.enableMovement		= enableMovement;
			
			// attach ability frame functions
			for (var i:String in frameFuncs) {
				var caster:StatUnit = this;
				var functionName:String = frameFuncs[i];
				
				var ff:Function = generateFrameFunction(caster, functionName);
				swf.content.char[functionName] = ff;
			}
		}		
	}
}