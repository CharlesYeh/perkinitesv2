package db.dbData {
	import db.AbilityDatabase;
	import db.ImageDatabase;
	
	import flash.display.MovieClip;
	import flash.display.Loader;
	
	import flash.net.URLRequest;
	
	import flash.events.IOErrorEvent;
	
	public class CharacterData extends UnitData implements DatabaseData {
		
		public var weapon:String;
		
		/** contains the grants to be given upon each level up */
		public var levelBonuses:Object;
		
		public var icon:Loader;
		
		override public function parseData(obj:Object):void {
			super.parseData(obj);
			
			weapon	= obj.weapon;
			
			icon = ImageDatabase.getIcon("Face Icon - " + obj.sprite + ".png");
			
			levelBonuses = obj.levelBonuses;
		}
	}
}