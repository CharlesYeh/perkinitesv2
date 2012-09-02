package game {
	
	import game.Game;
	import db.dbData.SoundData;
	import flash.media.SoundChannel;
	import flash.media.Sound;
	import flash.events.Event;
	
	public class SoundManager {
		
		public static var currentSong:String;
		public static var currentData:SoundData;
		public static var currentChannel:SoundChannel;
		
		public static function playSong(name:String):void {
			if (currentSong == name || name == null) {
				// do nothing
			}
			else {
				// change songs
				currentSong = name;
				
				currentData = Game.dbSnd.getSoundData(name);
				
				if (currentData.intro) {
					currentChannel = currentData.intro.play();
					currentChannel.addEventListener(Event.SOUND_COMPLETE, playLoop);
				}
				else {
					playLoop(null);
				}
			}
		}
		
		private static function playLoop(e:Event):void {
			if (e != null) {
				currentChannel.removeEventListener(Event.SOUND_COMPLETE, playLoop);
			}
			currentChannel = currentData.src.play(0, 99999999);
		}
		
		public static function endSong():void{
			currentChannel.stop();
		}
		
		public static function playSound():void{
			
		}
		
		public static function endSound():void{
			
		}
	}
	
}
