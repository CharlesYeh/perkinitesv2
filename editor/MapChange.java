   package editor;

   public class MapChange extends Change{
   
      private int index;
      private String mapCode;
      public MapChange(int i, String mc){
         super();
         index = i;
         mapCode = mc;
      }
      public int getIndex(){
         return index;
      }
      public String getMapCode(){
         return mapCode;
      }
   }