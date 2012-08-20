   package _editor;
   import java.awt.*;
   import java.util.*;
   
   
   public class Enemy implements Cloneable{
      private String id;
      private String direction;
      private Point position;
      private ArrayList<NPCAction> actions; //this is your sequence
      public Enemy(String i, String d, Point p){
         id = i;
         direction = d;
         position = p;
      }
      public String getID(){
         return id;
      }
      public String getDirection(){
         return direction;
      }
      public Point getPosition(){
         return position;
      }
      public void setID(String i){
         id = i;
      }
      public void setDirection(String d){
         direction = d;
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