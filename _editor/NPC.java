   package _editor;
   import java.awt.*;
   import java.util.*;
   
   
   public class NPC{
      private String sprite;
      private String direction;
      private Point position;
      private ArrayList<NPCAction> actions;
      public NPC(String s, String d, Point p, ArrayList<NPCAction> a){
         sprite = s;
         direction = d;
         position = p;
         actions = a;
      }
      public String getSprite(){
         return sprite;
      }
      public String getDirection(){
         return direction;
      }
      public Point getPosition(){
         return position;
      }
      public ArrayList<NPCAction> getActions(){
         return actions;
      }
      public void setSprite(String s){
         sprite = s;
      }
      public void setDirection(String d){
         direction = d;
      }
      public void setPosition(Point p){
         position = p;
      }
      //MODIFY ACTIONS
   }