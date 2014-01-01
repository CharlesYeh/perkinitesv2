package scripting.actions {
	
	import game.GameConstants;
	import game.Game;
	
	import db.dbData.MapCharacterData;
	
	import flash.geom.Point;
	
	public class ActionCreate extends Action{
		
		/** type of thing to delete */
		
		public var id:String;
		public var direction:String;
		public var position:Point;
		public var animation:String = "ANIM_STANDING";
		public var sequences:Array;
		
		public var playerIndex:int = -1;
		public var chosen:Boolean = false;
		
		override public function parseData(obj:Object):void {
			super.parseData(obj);
			
			id = obj.id;
			direction = obj.direction;
			position = new Point(obj.position.x, obj.position.y);
			animation = obj.animation;
			playerIndex = (obj.playerIndex != null) ? obj.playerIndex : -1;
			chosen = (obj.chosen != null) ? obj.chosen : false;
			sequences = obj.sequences;
		}
		
		override public function act():void {
			super.act();
			var dat:Object = new Object();
			
			if(chosen) {
				dat.id = Game.charID;
			} else if(playerIndex >= 0) {
				dat.id = Game.team[playerIndex % Game.team.length].unitData.id; 
			} else {
				dat.id = id;
			}
			dat.direction = direction;
			dat.position = position;
			dat.sequences = sequences;
			
			
			
			
			var cdat = new MapCharacterData();
			
			if(subtype == "enemy"){
				cdat.parseData(dat);
				
				Game.world.createEnemy(cdat);
			}
			else if(subtype == "npc"){
				cdat.parseData(dat);
				
				Game.world.createNPC(cdat);	
				
				var npcs = Game.world.getNPCs();
				npcs[npcs.length-1].animLabel = animation;
				//set usinganimation to false here
				npcs[npcs.length-1].beginAnimation(animation);
			}
			
			var o:Object = new Object();
			o.id = id;
			o.map = Game.playerProgress.map;
			o.direction = direction;
			o.position = position;
			o.animation = animation;
			o.subtype = subtype;
			Game.playerProgress.addCreatedUnit(o);
			complete();
		}
	}
}