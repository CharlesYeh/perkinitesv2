   package _editor;

   import java.awt.*;
   import java.util.*;
   
   import java.lang.reflect.Type;


   import com.google.gson.Gson;
   import com.google.gson.JsonElement;
   import com.google.gson.JsonObject;
   import com.google.gson.JsonParseException;
   import com.google.gson.stream.JsonWriter;
   
   import com.google.gson.reflect.TypeToken;
   
   import java.io.File;
   
   import java.io.BufferedReader;
   import java.io.FileWriter;
   import java.io.FileNotFoundException;
   import java.io.IOException;
   public class MapJSONWriter{
   
      public static ArrayList<Map> writeMapJSON(ArrayList<Map> mapArray){
         Gson gson = new Gson();
         
        
      
         File dir1 = new File(".");
         try {
            String path = dir1.getCanonicalPath() + "\\data\\maps\\";
            
         	
            try {
               JsonWriter writer = new JsonWriter(new FileWriter(path + "maps.json"));
               writer.setLenient(true);
               writer.setIndent("\t");
               
               writer.beginArray();
               for(int i = 0; i < mapArray.size(); i++){
                  writer.value(mapArray.get(i).getID());
               }
            		
               writer.endArray();  
               writer.close();                                
            }  
               catch (IOException e) {
                  e.printStackTrace();
               }
         	
            for(int i = 0; i < 1; i++){
               Map map = mapArray.get(i);
               System.out.println(path + map.getID() + ".json");
               try {
                  JsonWriter writer = new JsonWriter(new FileWriter(path + map.getID() + "_c.json"));
                  
                  writer.setLenient(true);
                  writer.setIndent("\t");
                     
                  writer.beginObject();
                  writer.name("name").value(map.getName()); 
                  writer.name("id").value(map.getID());
                  writer.name("tileset").value(map.getTileset());
                  writer.name("height").value(map.getHeight());
                  writer.name("width").value(map.getWidth());
                  writer.name("code").value(map.getCode());
                  if(map.getBGM().length() != 0){
                     writer.name("bgm").value(map.getBGM());
                  }  
                  if(map.getBGS().length() != 0){
                     writer.name("bgs").value(map.getBGS());
                  }
                  	//teleports
                  ArrayList<Teleport> teleports = map.getTeleports();
                     
                  if(teleports.size() != 0){
                     writer.name("teleports");
                     writer.beginArray();
                     
                     for(int j = 0; j < teleports.size(); j++){
                        Teleport teleport = teleports.get(j);
                        writer.beginObject();
                     
                        writer.name("entry");
                        writer.beginObject();
                        writer.setIndent("");
                        writer.name("x").value(teleport.getEntry().x);
                        writer.name("y").value(teleport.getEntry().y);
                        writer.endObject();
                     
                     
                        writer.setIndent("\t");
                        writer.name("exit");
                        writer.beginObject();
                        writer.setIndent("");
                        writer.name("map").value(teleport.getMap());
                        writer.name("x").value(teleport.getExit().x);
                        writer.name("y").value(teleport.getExit().y);
                        writer.endObject();
                     
                        writer.setIndent("\t");
                        writer.endObject();
                     }
                  	
                     writer.endArray();
                  }
                  ArrayList<Enemy> enemies = map.getEnemies();
                  	//enemies
                  if(enemies.size() != 0){
                     writer.name("enemies");
                     writer.beginArray();
                     
                     for(int j = 0; j < enemies.size(); j++){
                        Enemy enemy = enemies.get(j);
                        writer.beginObject();
                     
                        writer.name("id").value(enemy.getID());
                        writer.name("x").value(enemy.getPosition().x);
                        writer.name("y").value(enemy.getPosition().y);
                        writer.endObject();
                     }
                  	
                     writer.endArray();
                  
                  }
                
                  ArrayList<NPC> npcs = map.getNPCs();
                  	//npcs
                  if(npcs.size() != 0){
                     writer.name("npcs");
                     writer.beginArray();
                     for(int j = 0; j < npcs.size(); j++){
                        NPC npc = npcs.get(j);
                        writer.beginObject();
                     
                        if(npc.getID().length() != 0){
                           writer.name("id").value(npc.getID());
                        }
                        writer.name("sprite").value(npc.getSprite());
                        writer.name("direction").value(npc.getDirection());
                        writer.name("position");
                        writer.beginObject();
                        writer.setIndent("");
                        writer.name("x").value(npc.getPosition().x);
                        writer.name("y").value(npc.getPosition().y);
                        writer.endObject();  
                        writer.setIndent("\t");
                        
                        ArrayList<NPCAction> actions = npc.getActions();
                        if(actions.size() != 0){
                           writer.name("actions");
                           writer.beginArray();
                           for(int k = 0; k < actions.size(); k++){
                              NPCAction action = actions.get(k);
                              writer.beginObject();
                              
                              writer.name("type").value(action.getType());
                              if(action.getName() != null){
                                 writer.name("name").value(action.getName());
                              }
                              if(action.getFaceIcon() != null){
                                 writer.name("faceIcon").value(action.getFaceIcon());
                              }
                              if(action.getText() != null){
                                 writer.name("text").value(action.getText());
                              }
                              if(action.getDelta() != null){
                                 writer.name("delta");
                                 writer.beginObject();
                                 writer.setIndent("");
                                 writer.name("x").value(action.getDelta().x);
                                 writer.name("y").value(action.getDelta().y);
                                 writer.endObject();  
                                 writer.setIndent("\t");
                              
                              }
                           	
                              writer.endObject();
                           }
                           writer.endArray();
                        
                        }
                        
                        writer.endObject();
                     }
                  
                     writer.endArray();
                  }
                     
                  writer.endObject();
                  writer.close();
                                       
               }  
                  catch (IOException e) {
                     e.printStackTrace();
                  }
            
            } 
         }
            catch (Exception e) {
               e.printStackTrace();
            }
               
         return mapArray;
      }
   }