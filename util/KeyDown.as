package util{
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	public class KeyDown{
		public static const MOUSE:int = 999;
		static var keys = new Object;
		public static function init(stage){
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
			stage.addEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
		}
		public static function keyDownHandler(e:KeyboardEvent){
			keys[e.keyCode] = true;
		}
		public static function keyUpHandler(e:KeyboardEvent){
			delete keys[e.keyCode];
		}
		public static function mouseDownHandler(e:MouseEvent){
			keys[MOUSE] = true;
		}
		public static function mouseUpHandler(e:MouseEvent){
			delete keys[MOUSE];
		}
		public static function getKeyCode(s:String){
			return s.charCodeAt(0);
		}
		public static function keyIsDown(num){
			return keys[num];
		}
		public static function mouseIsDown(){
			return keys[MOUSE];
		}
	}
}
