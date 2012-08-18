   package _editor;
   import java.awt.*;
   
   
   public class Enemy implements Cloneable{
      private String id;
      private Point position;
      public Enemy(String i, Point p){
         id = i;
         position = p;
      }
      public String getID(){
         return id;
      }
      public Point getPosition(){
         return position;
      }
      public void setID(String i){
         id = i;
      }
      public void setPosition(Point p){
         position = p;
      }
   	
      @Override public Object clone() throws CloneNotSupportedException {
      //get initial bit-by-bit copy, which handles all immutable fields
         Enemy result = (Enemy)super.clone();
      
      
      
         return result;
      }
   }