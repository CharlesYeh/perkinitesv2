   package _editor;
   import java.awt.*;
   import java.util.*;
   
   
   public class NPCAction{
      private String type;
      private String name;
      private String faceIcon;
      private String text;
      private Point delta;
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
   }