package game{

    public class Tileset {

		public var ID:int
		public var tileTypes:Array;

        /**
         * 
		 * @param ID The ID of the tileset
         * @param tileTypes = "w", "f", "InteractiveTileName"
		 * 
         */
		
        public function Tileset() {
 			this.ID = 0;
			this.tileTypes = new Array();
        }
    }
}