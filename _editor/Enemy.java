   package _editor;
   import java.awt.*;
   
   
   public class Enemy{
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
   }