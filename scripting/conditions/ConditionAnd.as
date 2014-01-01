package scripting.conditions {
	
	import scripting.Sequence;
	import scripting.actions.Action;
	
	public class ConditionAnd extends Action {

		public var conditions:Array;
		
		override public function parseData(obj:Object):void {
			super.parseData(obj);
			
			conditions = new Array();
			
			var cond = obj.conditions;
			for(var i = 0; i < cond.length; i++){
				var a:Action = Sequence.createAction(cond[i].type);
				a.parseData(cond[i]);
				conditions.push(a);
			}
		}
		
		override public function update():Boolean {
			for(var i = 0; i < conditions.length; i++){
				if(!conditions[i].update()){
					reset();
					return super.update();
				}
			}
			
			complete();
			return super.update();
		}
	}
}