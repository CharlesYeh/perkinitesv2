package scripting.actions {
	
	import game.Game;
	
	public class ActionAnimate extends Action{
		/** the units to change referred to string*/
		public var units:Array;
		
		/** the thing to change to */
		public var animLabel:String;
				
		override public function parseData(obj:Object):void {
			super.parseData(obj);
			
			units = obj.units;
			
			animLabel = obj.animLabel;
		}

		override public function update():Boolean {
			/*var finished:Boolean = true;
			for(var i:String in units){
				if(units[i] == "player"){
					if(c[0].usingAnimation){
						finished = false;
						break;
					}
				} else if(units[i] == "partner"){
					if(c[1].usingAnimation){
						finished = false;
						break;
					}
				} else {
					
				}
				
			}
			if(finished){
				complete();
			}
			*/
			return super.update();
		}

		override public function act():void {
			super.act();
			var c = Game.world.getCustoms();
			//var n = Game.world.getNPCs();
			for(var i:String in units){
				if(units[i] == "player"){
					c[0].beginAnimation(animLabel);
				} else if(units[i] == "partner"){
					c[1].beginAnimation(animLabel);
				} else {
					
				}
				
			}
		}
	}
}