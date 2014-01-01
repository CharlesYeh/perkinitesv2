package db.dbData {
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	import game.Game;
	import scripting.Sequence;
	import scripting.actions.Action;
	
	public class MapCharacterData implements DatabaseData {
		public var id:String;
		public var direction:String;
		public var position:Point;
		
		public var actions:Dictionary = new Dictionary();
		public var conditions:Array = new Array();
		
		public function parseData(obj:Object):void {
			id	= obj.id;
			direction	= obj.direction;
			position	= new Point(obj.position.x, obj.position.y);
			for (var lbl:String in obj.sequences) {
				var seq:Sequence = Game.dbSeq.getSequence(obj.sequences[lbl]);
				actions[obj.sequences[lbl]] = seq;
			}
			
			var cond = obj.conditions;
			if(cond != null) {
				for(var i = 0; i < cond.length; i++){
					var a:Action = Sequence.createAction(cond[i].type);
					a.parseData(cond[i]);
					conditions.push(a);
				}
			}
		}
		
		public function resetConditions():void {
			for(var i = 0; i < conditions.length; i++){
				conditions[i].reset();
			}
		}
		
		public function checkConditions():Boolean {
			for(var i = 0; i < conditions.length; i++){
				conditions[i].act();
				if(!conditions[i].update()) {
					return false;
				}
			}
			return true;
		}
	}
	
}
