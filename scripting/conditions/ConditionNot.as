package scripting.conditions {
	
	
	import scripting.Sequence;
	import scripting.actions.Action;
	
	public class ConditionNot extends Action {

		public var condition:Action;
		
		override public function parseData(obj:Object):void {
			super.parseData(obj);
			
			condition = Sequence.createAction(obj.condition.type);
			condition.parseData(obj.condition);
		}
		
		override public function update():Boolean {
			if(!condition.update()){
				complete();
				return super.update();
			}
			
			reset();
			return super.update();
		}
	}
}