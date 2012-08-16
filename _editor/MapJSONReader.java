   package _editor;

   import java.awt.*;
   import java.util.*;
   
   import java.lang.reflect.Type;


   import com.google.gson.Gson;
   import com.google.gson.JsonElement;
   import com.google.gson.JsonObject;
   import com.google.gson.JsonParseException;
   import com.google.gson.stream.JsonReader;
   
   import com.google.gson.reflect.TypeToken;
   
   import java.io.File;
   
   import java.io.BufferedReader;
   import java.io.FileReader;
   import java.io.FileNotFoundException;
   import java.io.IOException;
   public class MapJSONReader{
   
      public static String[] readEnemyJSON(){
         ArrayList<String> enemies = new ArrayList<String>();
         Gson gson = new Gson();
         
         File dir1 = new File(".");
         try {
            String path = dir1.getCanonicalPath() + "\\data\\enemies\\";
           
            try {
            
               JsonReader reader = new JsonReader(new FileReader(path + "enemies.json"));
               
               reader.beginObject();
               reader.setLenient(true);
               String name = reader.nextName();
               reader.beginArray();
               while (reader.hasNext()) {
                  enemies.add(reader.nextString());
               }
               reader.endArray();
               reader.endObject();
               reader.close();
            }
               catch(FileNotFoundException e){
                  e.printStackTrace();
               }
         }
            catch(IOException e){
               e.printStackTrace();
            }
            
         return enemies.toArray(new String[enemies.size()]);
      }
      
   
   
   
      public static String[] readTilesetJSON(){
         ArrayList<String> tilesets = new ArrayList<String>();
         Gson gson = new Gson();
         
         File dir1 = new File(".");
         try {
            String path = dir1.getCanonicalPath() + "\\data\\maps\\";
           
            try {
            
               JsonReader reader = new JsonReader(new FileReader(path + "tilesets.json"));
               
               reader.beginObject();
               reader.setLenient(true);
               String name = reader.nextName();
               reader.beginArray();
               while (reader.hasNext()) {
                  reader.beginObject();
                  while(reader.hasNext()){
                     name = reader.nextName();
                     if(name.equals("id") || name.equals("name")){
                        tilesets.add(reader.nextString());
                     }
                     else{
                        reader.skipValue();
                     }
                  }
                  reader.endObject();
               }
               reader.endArray();
               reader.endObject();
               reader.close();
            }
               catch(FileNotFoundException e){
                  e.printStackTrace();
               }
         }
            catch(IOException e){
               e.printStackTrace();
            }
            
         return tilesets.toArray(new String[tilesets.size()]);
      }
      
      public static ArrayList<Map> readMapJSON(){
         ArrayList<Map> mapArray = new ArrayList<Map>();
         Gson gson = new Gson();
      
         File dir1 = new File(".");
         try {
            String path = dir1.getCanonicalPath() + "\\data\\maps\\";
           
            try {
            
               BufferedReader br = new BufferedReader(new FileReader(path + "maps.json"));
            
               ArrayList<String> mapFiles = new Gson().fromJson(br, 
                     new TypeToken<ArrayList<String>>(){}.getType());
                     
               for(int i = 0; i < mapFiles.size(); i++){
                  Map map = new Map();
                  System.out.println(path + mapFiles.get(i) + ".json");
                  try {
                     JsonReader reader = new JsonReader(new FileReader(path + mapFiles.get(i) + ".json"));
                  
                     reader.beginObject();
                     reader.setLenient(true);
                  
                     while (reader.hasNext()) {
                        String name = reader.nextName();
                        if (name.equals("name")) {
                           map.setName(reader.nextString());
                        } 
                        else if(name.equals("id")){
                           map.setID(reader.nextString());
                        }
                        else if(name.equals("tileset")){
                           map.setTileset(reader.nextString());
                        }
                        else if(name.equals("height")){
                           map.setHeight(reader.nextInt());
                        }
                        else if(name.equals("width")){
                           map.setWidth(reader.nextInt());
                        }
                        else if(name.equals("code")){
                           map.setCode(reader.nextString());
                        }
                        else if(name.equals("teleports")){
                           reader.beginArray();
                           
                           while (reader.hasNext()) {
                              Point entry = new Point(0,0);
                              Point exit = new Point(0,0);
                              String dest = "";
                              int x, y;
                              reader.beginObject();
                              
                           	//entry
                              while(reader.hasNext()){
                                 name = reader.nextName();
                                 if(name.equals("entry")){
                                    reader.beginObject();
                                    reader.nextName();
                                    x = reader.nextInt();
                                    reader.nextName();
                                    y = reader.nextInt();
                                    entry = new Point(x, y);
                                    reader.endObject();
                                 
                                 }
                                 else if(name.equals("exit")){
                                    reader.beginObject();
                                    reader.nextName();  
                                    dest = reader.nextString();
                                    reader.nextName();
                                    x = reader.nextInt();
                                    reader.nextName();
                                    y = reader.nextInt();
                                    exit = new Point(x, y);
                                    reader.endObject();	
                                 }
                                 else{
                                    reader.skipValue();
                                 }
                              
                              }
                              
                              map.addTeleport(new Teleport(entry, dest, exit));
                              reader.endObject();
                           }
                           reader.endArray();
                        }
                        else if(name.equals("npcs")){
                           String sprite = "";
                           String direction = "";
                           Point position = new Point(0,0);
                           ArrayList<NPCAction> actions = new ArrayList<NPCAction>();
                           int x, y;
                        
                        
                           reader.beginArray();
                           
                           while (reader.hasNext()) {
                              
                              reader.beginObject();
                              while(reader.hasNext()){
                                 name = reader.nextName();
                                 switch(name){
                                    case "sprite":
                                       sprite = reader.nextString();
                                       break;
                                    case "direction":
                                       direction = reader.nextString();
                                       break;
                                    case "position":
                                       reader.beginObject();
                                       reader.nextName();
                                       x = reader.nextInt();
                                       reader.nextName();
                                       y = reader.nextInt();
                                       position = new Point(x, y);
                                       reader.endObject();
                                       break;
                                    case "actions":
                                       reader.beginArray();
                                       while(reader.hasNext()){
                                          reader.beginObject();
                                          NPCAction a = new NPCAction();
                                       
                                          while(reader.hasNext()){
                                             name = reader.nextName();
                                             switch(name){
                                                case "type":
                                                   a.setType(reader.nextString());
                                                   break;
                                                default:
                                                   reader.skipValue();
                                                   break;
                                             }
                                          }
                                          actions.add(a);
                                          reader.endObject();
                                       }
                                       reader.endArray();
                                       break;
                                    default:
                                       reader.skipValue();
                                       break;
                                 }
                              }
                              map.addNPC(new NPC(sprite, direction, position, null));
                              reader.endObject();
                             
                           }
                        
                           reader.endArray();
                        }
                        else if(name.equals("enemies")){
                           reader.beginArray();
                           
                           while (reader.hasNext()) {
                              String id = "";
                              Point position = new Point(0,0);
                              int x = 0;
                              int y = 0;
                              reader.beginObject();
                              
                           	//entry
                              while(reader.hasNext()){
                                 name = reader.nextName();
                                 switch(name){
                                    case "id":
                                       id = reader.nextString();
                                       break;
                                    case "x":
                                       x = reader.nextInt();
                                       break;
                                    case "y":
                                       y = reader.nextInt();
                                       break;
                                    default:
                                       reader.skipValue();
                                       break;
                                 }
                                                              
                              }
                              position = new Point(x, y);
                              map.addEnemy(new Enemy(id, position));
                              reader.endObject();
                           }
                           reader.endArray();
                        
                        }
                        else {
                           reader.skipValue();
                        }
                     }
                     reader.endObject();
                     reader.close();
                     
                     map.createMap();
                     mapArray.add(map);
                  
                  } 
                     catch (FileNotFoundException e) {
                        e.printStackTrace();
                     } 
                     catch (IOException e) {
                        e.printStackTrace();
                     }
               }
            
            } 
               catch (IOException e) {
                  e.printStackTrace();
               }
         
         } 
            catch (Exception e) {
               e.printStackTrace();
            }
               
         return mapArray;
      }
   }