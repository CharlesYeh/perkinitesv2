   package _editor;
   
   import java.util.*;
   
   public class Map  implements Cloneable{
   
   
      private String name;
      private String id;
      private String tileset;
      private int height;
      private int width;
      private String code;
      
      private ArrayList<Teleport> teleports;
      private ArrayList<Enemy> enemies;
      private ArrayList<NPC> npcs;
      
      private int[][] mapMatrix;
      
      private String BGM;
      private String BGS;
      public Map(){
         name = "";
         id = "";
         tileset = "";
         height = 15;
         width = 20;
         code = "";
         
         teleports  = new ArrayList<Teleport>();
         enemies = new ArrayList<Enemy>();
         npcs = new ArrayList<NPC>();
      
         BGM = "";
         BGS = "";
           
      }
      public String getName(){
         return name;
      }
      public String getCode(){
         return code;
      }
      public String getBGM(){
         return BGM;
      }
      public String getBGS(){
         return BGS;
      }
      public int getWidth(){
         return width;
      }
      public int getHeight(){
         return height;
      }
      public String getID(){
         return id;
      }
      public String getTileset(){
         return tileset;
      }
      public int[][] getMapMatrix(){
         return mapMatrix;
      }
      public ArrayList<Teleport> getTeleports(){
         return teleports;
      }
      public ArrayList<Enemy> getEnemies(){
         return enemies;
      }
      public ArrayList<NPC> getNPCs(){
         return npcs;
      }
      public void setName(String n){
         name = n;
      }
      public void setID(String i){
         id = i;
      }
      public void setTileset(String t){
         tileset = t;
      }
      public void setCode(String c){
         code = c;
      }
      public void setMapMatrix(int[][] mm){
         mapMatrix = mm;
      }
      public void setBGM(String bgm){
         BGM = bgm;
      }
      public void setBGS(String bgs){
         BGS = bgs;
      }
      public void setWidth(int w){
         width = w;   
      }
      public void setHeight(int h){
         height = h;
      }
   
      public void setTeleports(ArrayList<Teleport> ts){
         teleports = ts;
      }
      public void addTeleport(Teleport teleport){
         teleports.add(teleport);
      }
      public void addNPC(NPC npc){
         npcs.add(npc);
      }
      public void setNPCs(ArrayList<NPC> NPCs){
         npcs = NPCs;
      }
      public void setEnemies(ArrayList<Enemy> es){
         enemies = es;
      }
      public void addEnemy(Enemy enemy){
         enemies.add(enemy);
      }
   	/*
   	 * Creates the initial map before any edits. Everything besides mapMatrix should be filled in already.
   	 */
      public void createMap(){
         mapMatrix = new int[height][width];
      
         int index = 0;
         for(int i = 0; i < height; i++){
            for(int j = 0; j < width; j++){
               String tileID = code.substring(index, index+1);
            //check if substring is a letter or not
               if(Character.isLetter(tileID.charAt(0))){
                  mapMatrix[i][j] = tileID.charAt(0) - 55;
               }
               else{
               //if not
                  mapMatrix[i][j] = Integer.parseInt(tileID);
               }
               index++;
            }
         }
         
      }
      
   
      /*
   	 * Changes the map to account for width/height changes. This is mostly used from the MapProperties window.
   	 */  
      public void updateMap(int oldHeight, int oldWidth){
         int[][] temp = new int[height][width];
         int row;
         int col;
         if(height < oldHeight){
            row = height;
         }
         else{
            row = oldHeight;
         }
         if(width < oldWidth){
            col = width;
         }
         else{
            col = oldWidth;
         }
         
         for(int i = 0; i < height; i++){
            for(int j = 0; j < width; j++){
               temp[i][j] = 0;
            }
         }
         for(int i = 0; i < row; i++){
            for(int j = 0; j < col; j++){
               temp[i][j] = mapMatrix[i][j];
            }
         }
         
         mapMatrix = temp;
         
      	//Delete any objects lost in the transformation.
         for(int i = 0; i < teleports.size(); i++){
            Teleport teleport = teleports.get(i);
            if(teleport.getEntry().x >= width || teleport.getEntry().y >= height){
               teleports.remove(i);
               i--;
            }
         }
         for(int i = 0; i < enemies.size(); i++){
            Enemy enemy = enemies.get(i);
            if(enemy.getPosition().x >= width || enemy.getPosition().y >= height){
               enemies.remove(i);
               i--;
            }
         
         }
         for(int i = 0; i < npcs.size(); i++){
            NPC npc = npcs.get(i);
            if(npc.getPosition().x >= width || npc.getPosition().y >= height){
               npcs.remove(i);
               i--;
            }
         
         }
      }
      
      public void updateMapCode(){
         code = "";
         for(int i = 0; i < height; i++){
            for(int j = 0; j < width; j++){
               if(mapMatrix[i][j] >= 10){
                  code+= (char)(mapMatrix[i][j]+55);
               }
               else{
                  code += mapMatrix[i][j];
               }
               
            }
         }
      
      }
      
      public void changeTile(int r, int c, int tileID){
         mapMatrix[r][c] = tileID;
      }
      public int getTile(int r, int c){
         return mapMatrix[r][c];
      }
         	
      @Override public Object clone() throws CloneNotSupportedException {
      //get initial bit-by-bit copy, which handles all immutable fields
         Map result = (Map)super.clone();
      
         int [][] copiedMapMatrix = new int[mapMatrix.length][];
         for(int i = 0; i < mapMatrix.length; i++)
            copiedMapMatrix[i] = mapMatrix[i].clone();
         	
         result.setMapMatrix(copiedMapMatrix);
         
         ArrayList<Teleport> newTeleports = new ArrayList<Teleport>();
         ArrayList<Enemy> newEnemies = new ArrayList<Enemy>();
         ArrayList<NPC> newNPCs = new ArrayList<NPC>();
         
         for(int i = 0; i < teleports.size(); i++){
            newTeleports.add((Teleport)teleports.get(i).clone());
         }
         for(int i = 0; i < enemies.size(); i++){
            newEnemies.add((Enemy)enemies.get(i).clone());
         }
         for(int i = 0; i < npcs.size(); i++){
            newNPCs.add((NPC)npcs.get(i).clone());
         }
      
         result.setTeleports(newTeleports);
         result.setEnemies(newEnemies);
         result.setNPCs(newNPCs);
            
         return result;
      }
   }