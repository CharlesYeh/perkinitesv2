   package _editor;
   import java.awt.*;
   import java.util.*;
   
   
   public class NPCAction{
      private String type;
      private String name;
      private String faceIcon;
      private String text;
      private Point delta;
      private String state;
      private NPCAction action;
      public NPCAction(){
      }
      public String getType(){
         return type;
      }
      public String getName(){
         return name;
      }
      public String getFaceIcon(){
         return faceIcon;
      }
      public String getText(){
         return text;
      }
      public Point getDelta(){
         return delta;
      }
      public String getState(){
         return state;
      }
      public NPCAction getAction(){
         return action;
      }
      public void setType(String t){
         type = t;
      }
      public void setName(String n){
         name = n;
      }
      public void setFaceIcon(String fi){
         faceIcon = fi;
      }
      public void setText(String t){
         text = t;
      }
      public void setDelta(Point d){
         delta = d;
      }
      public void setState(String s){
         state = s;
      }
      public void setAction(NPCAction a){
         action = a;
      }
      
      public String getDisplay(){
         return "Yay";
      }
   }