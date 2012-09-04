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
		
		override public function parseData(obj:Object):void {
			super.parseData(obj);
			
			id = obj.id;
			direction = obj.direction;
			position = new Point(obj.position.x, obj.position.y);
			animation = obj.animation;
		}
		
		override public function act():void {
			super.act();
			var dat:Object = new Object();
			dat.id = id;
			dat.direction = direction;
			dat.position = position;
			
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
				npcs[npcs.length-1].beginAnimation(animation);
			}
			
			complete();
		}
	}
}