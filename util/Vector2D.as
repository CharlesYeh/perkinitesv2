//CLASS: com.lgrey.vectors.Vector2D 
//created by Lee Grey
 
package util {
	import flash.geom.Point;
	
	public class Vector2D {
	
		public var x:Number = 0;
		public var y:Number = 0;
		
		public function Vector2D(dx:Number = 0, dy:Number = 0){
			x = dx;
			y = dy;
		}
		
		public function initFromPoint( p:Point ):Vector2D
		{
			x = p.x;
			y = p.y;
			return this;
		}
		
		public function reset():Vector2D {
			x = 0;
			y = 0;
			return this;
		}
		//
		public function add(ov:*):Vector2D {
			x += ov.x;
			y += ov.y;
			return this;
		}
		//
		public function subtract(ov:*):Vector2D {
			x -= ov.x;
			y -= ov.y;
			return this;
		}
 
		public function multiply(ov:*):Vector2D {
			x *= ov.x;
			y *= ov.y;
			return this;
		}
 
		//apply scalars		
		public function multiplyLength(o:*):Vector2D {
			x *= o;
			y *= o;
			return this;
		}
 
		public function divideLength(o:*):Vector2D {
			x /= o;
			y /= o;
			return this;
		}
		
		//give() gives the x,y values of this instance to another
		public function give(ov:*):Vector2D {
			ov.x = x;
			ov.y = y;
			return this;
		}
		
		//copy() copies the x,y values of another instance to this
		public function copy(ov:*):Vector2D {
			x = ov.x;
			y = ov.y;
			return this;
		}
		
		public function set angle(n:Number):void {
			x = Math.cos(n)*length;
			y = Math.sin(n)*length;
		}
		
		public function set angleDeg(n:Number):void {
			n *= 0.0174532925;
			x = Math.cos(n)*length;
			y = Math.sin(n)*length;
		}
		
		public function setAngle(n:Number):Vector2D {
			x = Math.cos(n)*length;
			y = Math.sin(n) * length;
			return this;
		}
 
		public function setAngleDeg(n:Number):Vector2D {
			n *= 0.0174532925;
			x = Math.cos(n)*length;
			y = Math.sin(n) * length;
			return this;
		}
 
		public function rotateBy(n:Number):Vector2D {
			var angle:Number = getAngle();
			var length:Number = Math.sqrt(x*x+y*y);
			x = Math.cos(n+angle)*length;
			y = Math.sin(n + angle) * length;
			return this;
		}
		
		public function rotateByDeg(n:Number):Vector2D {
			n *= 0.0174532925;
			rotateBy(n);
			return this;
		}
 
		public function normalise( n:Number = 1.0 ):Vector2D {
			normalize(n);
			return this;
		}
 
		public function normalize( n:Number = 1.0 ):Vector2D {
			var length:Number = Math.sqrt(x*x+y*y);
			x = (x/length) * n;
			y = (y / length) * n;
			return this;
		}
	
		public function get length():Number {
			return (Math.sqrt(x*x+y*y));
		}
		
		public function getLength():Number {
			return ( Math.sqrt(x*x+y*y) );
		}
		
		public function getLength2():Number {
			return x*x+y*y;
		}
 
		public function set length( newlength:Number ):void {
			normalize(1);
			x *= newlength;
			y *= newlength;
		}
		
		public function setLength(newlength:Number):Vector2D {
			normalize(1);
			x *= newlength;
			y *= newlength;
			return this;
		}
		//
		public function getAngle():Number {
			return (Math.atan2(y,x));
		}
		
		public function getAngleDeg():Number {
			return (Math.atan2(y,x) * 57.2957 );
		}
		//
		public function dot(ov:*):Number {
			return (x*ov.x+y*ov.y);
		}
 
		public function clone():Vector2D
		{
			return new Vector2D(x, y)
		}
		
		public function zero():Vector2D
		{
			x = 0;
			y = 0;
			return this;
		}
		
		public function lookAt( ov:* ):Vector2D
		{
			var vectorToTarget:Vector2D = new Vector2D( ov.x - x, ov.y - y  );
			setAngle( vectorToTarget.getAngle() );
			return this;
		}
 
		//operations returning new Vectors
		
		public function minus(ov:*):Vector2D {
			return new Vector2D( x -= ov.x, y -= ov.y );
		}
 
		//public function times(ov:*):void {
			//return new Vector2D( x * ov.x, y * ov.y );
		//}
				
		public function smult(scalar:Number):Vector2D {
			return new Vector2D( x * scalar, y * scalar );
		}
		
		public function pmult(ov:*):Vector2D {
			return new Vector2D( x * ov.x, y * ov.y);
		}
 
		public function plus(ov:*):Vector2D {
			return new Vector2D( x += ov.x, y += ov.y );
		}
		
		public function projectOntoLine(p1:Vector2D, p2:Vector2D):Vector2D {
			var between = p2.minus(p1);
			var orig = clone();
			return p1.plus(between.smult(orig.minus(p1).dot(between) / between.getLength2()));
		}
		
		public function dist(ov: *):Number {
			var dx = x - ov.x;
			var dy = y - ov.y;
			return Math.sqrt(dx*dx + dy*dy);
		}
		
		public function dist2(ov: *):Number {
			var dx = x - ov.x;
			var dy = y - ov.y;
			return dx*dx + dy*dy;
		}		

	}
} // end class