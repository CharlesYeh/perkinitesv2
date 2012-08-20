package db.dbData {
	import db.AbilityDatabase;
	
	import flash.display.MovieClip;
	import flash.display.Loader;
	
	import flash.net.URLRequest;
	
	public class CharacterData extends UnitData implements DatabaseData {
		
		public var weapon:String;
		
		/** contains the grants to be given upon each level up */
		public var levelBonuses:Object;
		
		public var icon:Loader;
		
		override public function parseData(obj:Object):void {
			super.parseData(obj);
			
			weapon	= obj.weapon;
			
			var iconURL:URLRequest = new URLRequest("assets/icons/Face Icon - " + obj.sprite + ".png");
			icon = new Loader();
			icon.load(iconURL);
			
			levelBonuses= obj.levelBonuses;
		}
	}
}