package game {
	
	import game.Game;
	import db.dbData.SoundData;
	import flash.media.SoundChannel;
	import flash.media.Sound;
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	public class SoundManager {
		
		public static var currentSong:String;
		public static var currentData:SoundData;
		public static var currentChannel:SoundChannel;
		
		public static var playingSounds:Array = new Array();
		public static var pausePositions:Dictionary = new Dictionary();
		public static var channelSources:Dictionary = new Dictionary();
		
		public static function playSong(name:String):void {
			if (currentChannel == null || (currentSong != name && name == null)) {
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
			currentChannel = null;
		}
		
		/**
		 * play a sound once
		 */
		public static function playSound(snd:String):void{
			var dat:SoundData = Game.dbSnd.getSoundData(snd);
			
			var ch:SoundChannel = dat.src.play()
			ch.addEventListener(Event.SOUND_COMPLETE, soundComplete);
			
			playingSounds.push(ch);
			channelSources[ch] = dat.src;
		}
		
		/**
		 * remove a sound from the list of in-progress sounds
		 */
		private static function soundComplete(e:Event) {
			var ch:SoundChannel = e.target as SoundChannel;
			
			ch.removeEventListener(Event.SOUND_COMPLETE, soundComplete);
			playingSounds.splice(playingSounds.indexOf(ch), 1);
			delete channelSources[ch];
		}
		
		/**
		 * pause all sounds, saving their time positions
		 */
		public static function pauseSounds():void {
			for (var i:String in playingSounds) {
				var ch:SoundChannel = playingSounds[i];
				
				pausePositions[ch] = ch.position;
				ch.stop();
			}
		}
		
		/**
		 * resume sounds using dictionary pause positions to jump to the right point
		 */
		public static function resumeSounds():void {
			for (var key:String in pausePositions) {
				var ch:SoundChannel = key as SoundChannel;
				
				// replace current channel with new one for resumed sound
				var snd:Sound = channelSources[ch];
				playingSounds[playingSounds.indexOf(ch)] = snd.play(pausePositions[ch], 0);
			}
			
			pausePositions = new Dictionary();
		}
	}
	
}
