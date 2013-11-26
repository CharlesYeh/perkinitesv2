package db.dbData {
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	import game.Game;
	import scripting.Sequence;
	
	public class MapCharacterData implements DatabaseData {
		public var id:String;
		public var direction:String;
		public var position:Point;
		
		public var actions:Dictionary = new Dictionary();
		
		public function parseData(obj:Object):void {
			id	= obj.id;
			direction	= obj.direction;
			position	= new Point(obj.position.x, obj.position.y);
			for (var lbl:String in obj.sequences) {
				var seq:Sequence = Game.dbSeq.getSequence(obj.sequences[lbl]);
				actions[obj.sequences[lbl]] = seq;
			}
		}
	}
	
}
