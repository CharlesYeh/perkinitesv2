   package _editor;

   public class MapChange extends Change{
   
      private int _index;
      private Map _map;
      public MapChange(int i, Map map){
         super();
         _index = i;
         _map = map;
      }
      public int getIndex(){
         return _index;
      }
      public Map getMap(){
         return _map;
      }
   }