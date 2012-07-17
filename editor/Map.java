   package editor;

   public class Map{
   
      private String mapName;
      private String mapCode;
      private String BGM;
      private String BGS;
      private int tilesetID;
      private int width;
      private int height;
      public Map(){
      
      }
      public String getMapName(){
         return mapName;
      }
      public String getMapCode(){
         return mapCode;
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
      public int getTilesetID(){
         return tilesetID;
      }
      public void setMapName(String mn){
         mapName = mn;
      }
      public void setMapCode(String mc){
         mapCode = mc;
         int index1 = mapCode.indexOf(":");
         int index2 = mapCode.indexOf(":", index1+1);
         height = Integer.parseInt(mapCode.substring(0, index1));
         width = Integer.parseInt(mapCode.substring(index1+1, index2));
      }
      public void setBGM(String bgm){
         BGM = bgm;
      }
      public void setBGS(String bgs){
         BGS = bgs;
      }
      public void setTilesetID(int tID){
         tilesetID = tID;
      }
      public void setWidth(int w){
         width = w;
         int index1 = mapCode.indexOf(":");
         int index2 = mapCode.indexOf(":", index1+1);
         mapCode = mapCode.substring(0, index1+1) + width + mapCode.substring(index2);
      }
      public void setHeight(int h){
         height = h;
         int index1 = mapCode.indexOf(":");
         int index2 = mapCode.indexOf(":", index1+1);
         mapCode = height + mapCode.substring(index1);
      }
   	
   }