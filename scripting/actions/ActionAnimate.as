package scripting.actions {
	
	import game.Game;
	
	public class ActionAnimate extends Action{
		/** the sprite to change referred to string*/
		public var sprite:String;
		
		/** the thing to change to */
		public var animation:String;
		
		//include something for player and partner here too
		
		/** the units being changed */
		private var units:Array = new Array();
				
		private var m_time;
		override public function parseData(obj:Object):void {
			super.parseData(obj);
			
			sprite = obj.sprite;
			animation = obj.animation;
		}

		override public function update():Boolean {
			if(time > 0){
				m_time--;
				if (m_time <= 0) {
					for(var i:String in units){
						units[i].endAnimation();
					}				
					complete();
				}
			}
			
		
			return super.update();
		}
		
		override public function act():void {
			super.act();
			var c = Game.world.getCustoms();
			
			var n = Game.world.getNPCs();
			for(var i:String in n){
				if(n[i].mapCharacterData.id == sprite){
					n[i].beginAnimation(animation);
					units.push(n[i]);
				}
			}
			m_time = time;
			if(units.length == 0 || time == 0){
				complete();
			}
/*			for(var i:String in units){
				if(units[i] == "player"){
					c[0].beginAnimation(animLabel);
				} else if(units[i] == "partner"){
					c[1].beginAnimation(animLabel);
				} else {
					
				}
			}*/
		}
	}
}