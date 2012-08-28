package util {
	import flash.text.TextField;

	public class TextUtil {
		public static function vertAlign(tf:TextField, y:Number):void {
			tf.y = y - tf.textHeight / 2;
		}
	}
}