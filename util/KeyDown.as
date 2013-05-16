package util{
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.display.Stage;
	import flash.geom.Point;
	
	public class KeyDown{
		public static const MOUSE:int = 999;
		private static var keys:Object = new Object;
		
		private static var listeners:Object = new Object();
		
		public static var mousePoint:Point;
		
		public static function init(stage){
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
			stage.addEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			stage.addEventListener("rightMouseDown", mouseDownHandler);
			stage.addEventListener("rightMouseUp", mouseUpHandler);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseTracker);
			
			mousePoint = new Point();
		}
		
		public static function subscribe(evtType:String, func:Function):void {
			if (listeners[evtType] == null) {
				listeners[evtType] = new Array();
			}
			
			var typeListeners:Array = listeners[evtType];
			typeListeners.push(func);
		}
		
		public static function unsubscribe(evtType:String, func:Function):void {
			var typeListeners:Array = listeners[evtType];
			var index:int = typeListeners.indexOf(func);
			
			if (index != -1) {
				typeListeners.splice();
			}
		}
		
		public static function keyDownHandler(e:KeyboardEvent){
			broadcast(e);
			keys[e.keyCode] = true;
		}
		
		public static function keyUpHandler(e:KeyboardEvent){
			broadcast(e);
			delete keys[e.keyCode];
		}
		
		public static function mouseDownHandler(e:MouseEvent){
			broadcast(e);
			keys[MOUSE] = true;
		}
		
		public static function mouseUpHandler(e:MouseEvent){
			broadcast(e);
			delete keys[MOUSE];
		}
		
		public static function mouseTracker(e:MouseEvent) {
			mousePoint.x = e.stageX;
			mousePoint.y = e.stageY;
			//trace(mousePoint);
		}
		
		private static function broadcast(e:Event):void {
			var typeListeners:Array = listeners[e.type];
			
			if (typeListeners != null) {
				for (var i:String in typeListeners) {
					typeListeners[i](e);
				}
			}
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
