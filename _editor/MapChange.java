   package editor;

   public class MapChange extends Change{
   
      private int _index;
      private int[][] _mapMatrix;
      public MapChange(int i, int[][] mapMatrix){
         super();
         _index = i;
         _mapMatrix = mapMatrix;
      }
      public int getIndex(){
         return _index;
      }
      public int[][] getMapMatrix(){
         return _mapMatrix;
      }
   }