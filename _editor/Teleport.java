   package _editor;
   import java.awt.*;
   
   
   public class Teleport implements Cloneable{
      private Point entry;
      private String map;
      private Point exit;
      public Teleport(Point en, String m, Point ex){
         entry = en;
         map = m;
         exit = ex;
      }
      public Point getEntry(){
         return entry;
      }
      public String getMap(){
         return map;
      }
      public Point getExit(){
         return exit;
      }
      public void setEntry(Point en){
         entry = en;
      }
      public void setMap(String m){
         map = m;
      }
      public void setExit(Point ex){
         exit = ex;
      }
      @Override public Object clone() throws CloneNotSupportedException {
      //get initial bit-by-bit copy, which handles all immutable fields
         Teleport result = (Teleport)super.clone();
      
      
      
         return result;
      }
   }