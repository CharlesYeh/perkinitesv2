package db.dbData {
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	public class MapCharacterData implements DatabaseData {
		public var id:String;
		public var direction:String;
		public var position:Point;
		
		public var actions:Dictionary;
		
		public function parseData(obj:Object):void {
			id	= obj.id;
			direction	= obj.direction;
			position	= new Point(obj.position.x, obj.position.y);
			for (var lbl:String in obj.actions) {
				var seq:SequenceData = new SequenceData();
				seq.parseData(obj.actions[lbl]);
				actions[lbl] = seq;
			}
		}
	}
	
}
