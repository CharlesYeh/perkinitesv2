   package _editor;
   import java.awt.*;
   import java.util.*;
   
   
   public class NPC implements Cloneable{
      private String id;
      private String sprite;
      private String direction;
      private Point position;
      private ArrayList<NPCSequence> sequences;
      public NPC(String ID, String s, String d, Point p, ArrayList<NPCSequence> seq){
         id = ID;
         sprite = s;
         direction = d;
         position = p;
         sequences = seq;
      }
      public String getID(){
         return id;
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
      public ArrayList<NPCSequence> getSequences(){
         return sequences;
      }
      public void setID(String ID){
         id = ID;
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
      public void setSequences(ArrayList<NPCSequence> seq){
         sequences = seq;
      }
      //MODIFY ACTIONS
   	
      @Override public Object clone() throws CloneNotSupportedException {
      //get initial bit-by-bit copy, which handles all immutable fields
         NPC result = (NPC)super.clone();
      
      
      
         return result;
      }
   
   }