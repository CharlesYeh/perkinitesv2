package scripting.controls{
	
	import game.Game;
	import scripting.Sequence;
	import scripting.actions.Action;
	
	public class Control extends Action{
		/** the conditions needed for this to be true*/
		public var conditions:Array;
		
		public var ifSequence:Sequence;
		public var elseSequence:Sequence;
		
		public var conditionsChecked:Boolean = false;
		public var conditionsMet:Boolean = true;
		override public function parseData(obj:Object):void {
			super.parseData(obj);
			
			conditions = new Array();
			
			var cond = obj.conditions;
			for(var i = 0; i < cond.length; i++){
				var a:Action = Sequence.createAction(cond[i].type);
				a.parseData(cond[i]);
				conditions.push(a);
			}
			
			var ifSeq = obj.ifSequence;
			var elseSeq = obj.elseSequence;
			
			ifSequence = new Sequence();
			elseSequence = new Sequence();
			if(ifSeq != null) {
				ifSequence.parseData(ifSeq);
				ifSequence.repeatable = true;
				ifSequence.saveable = false;
			}
			if(elseSeq != null) {
				elseSequence.parseData(elseSeq);
				elseSequence.repeatable = true;
				elseSequence.saveable = false;
			}
		}

		override public function update():Boolean {
			if(!conditionsChecked) {
				checkConditions();
			}			
			if(conditionsMet) {
				ifSequence.updateActions();
				if(ifSequence.update()){
					complete();
				}
			} else {
				elseSequence.updateActions();
				if(elseSequence.update()){
					complete();
				}
				
			}
	
			return super.update();
		}
		
		override public function reset():void {
			conditionsChecked = false;
			for(var i = 0; i < conditions.length; i++){
				conditions[i].reset();
			}
		}
		override public function complete():void {
			super.complete();
			conditionsChecked = false;
		}
		
		override public function act():void {
			super.act();
			
			conditionsChecked = false;
			
			if(!conditionsChecked) {
				checkConditions();
			}
			
			if(conditionsMet) {
				ifSequence.start();
			} else {
				elseSequence.start();
			}
		}
		
		protected function checkConditions():void {
			//check all the conditions
			conditionsChecked = true;
			for(var i = 0; i < conditions.length; i++){
				conditions[i].act();
				if(!conditions[i].update()) {
					conditionsMet = false;
					break;
				}
			}
		}
	}
}