   package _editor;

   import java.awt.*;
   import java.util.*;
   
   import java.lang.reflect.Type;

   import com.google.gson.ExclusionStrategy;

   import com.google.gson.FieldAttributes;
   import com.google.gson.Gson;
   import com.google.gson.GsonBuilder;
   import com.google.gson.JsonArray;
   import com.google.gson.JsonElement;
   import com.google.gson.JsonObject;
   import com.google.gson.JsonPrimitive;
   import com.google.gson.JsonSerializer;
   import com.google.gson.JsonSerializationContext;
   import com.google.gson.JsonParseException;
   import com.google.gson.stream.JsonWriter;
   
   import com.google.gson.reflect.TypeToken;
   
   import java.io.File;
   
   import java.io.BufferedReader;
   import java.io.FileWriter;
   import java.io.FileNotFoundException;
   import java.io.IOException;
   public class MapJSONWriter{
   
      private static class MyExclusionStrategy implements ExclusionStrategy {
         private final Class<?> typeToSkip;
      
         private MyExclusionStrategy(Class<?> typeToSkip) {
            this.typeToSkip = typeToSkip;
         }
      
         public boolean shouldSkipClass(Class<?> clazz) {
            return (clazz == typeToSkip);
         }
      
         public boolean shouldSkipField(FieldAttributes f) {
            return f.getName().equals("mapMatrix");
         }
      }
      
      private static class StringSerializer implements JsonSerializer<String> {
         public JsonElement serialize(String src, Type typeOfSrc, JsonSerializationContext context) {
            if(src.toString().length() == 0){
               return null;
            }
            return new JsonPrimitive(src.toString());
         }
      }
      private static class TeleportSerializer implements JsonSerializer<Teleport> {
         public JsonElement serialize(Teleport src, Type typeOfSrc, JsonSerializationContext context) {
         
            JsonObject entry = new JsonObject();
            entry.addProperty("x", src.getEntry().x);
            entry.addProperty("y", src.getEntry().y);
            JsonObject exit = new JsonObject();
            exit.addProperty("map", src.getMap());
            exit.addProperty("x", src.getExit().x);
            exit.addProperty("y", src.getExit().y); 
            JsonObject obj = new JsonObject();
            obj.add("entry", entry);
            obj.add("exit", exit);
         
            return obj;
         }
      }  
      
      public static ArrayList<Map> writeMapJSON(ArrayList<Map> mapArray){
         Gson gson = new GsonBuilder()
            .setPrettyPrinting()
            .setExclusionStrategies(new MyExclusionStrategy(NPC.class))
            .registerTypeAdapter(String.class, new StringSerializer())
            .registerTypeAdapter(Teleport.class, new TeleportSerializer())
            .create();
        
         File dir1 = new File(".");
         try {
            String path = dir1.getCanonicalPath() + "\\assets\\data\\maps\\";
            
         	
            try {
               JsonWriter writer = new JsonWriter(new FileWriter(path + "maps.json"));
               writer.setLenient(true);
               writer.setIndent("\t");
               
               writer.beginObject();
               writer.name("maps");
               writer.beginArray();
               for(int i = 0; i < mapArray.size(); i++){
                  writer.value(mapArray.get(i).getID());
               }
            		
               writer.endArray();  
               writer.endObject();
               writer.close();                                
            }  
               catch (IOException e) {
                  e.printStackTrace();
               }
            for(int i = 0; i < mapArray.size(); i++){
               Map map = mapArray.get(i);
            
               String json = gson.toJson(map);
            
               try {
                  FileWriter writer = new FileWriter(path + map.getID() + ".json");
                  writer.write(json);
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