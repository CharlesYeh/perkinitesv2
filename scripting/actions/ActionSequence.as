package scripting.actions{
	
	import game.Game;
	import scripting.Sequence;
	
	/** Given an id, calls the appropriate sequence from the database. */
	
	public class ActionSequence extends Action{
		
		public var sequence:Sequence;
		
		override public function parseData(obj:Object):void {
			super.parseData(obj);
			
			sequence = Game.dbSeq.getSequence(obj.name);
		}

		override public function update():Boolean {
			sequence.updateActions();
			if(sequence.update()) {
				complete();
			}
	
			return super.update();
		}
		
		override public function act():void {
			super.act();
			
			sequence.start();
		}
	}
}