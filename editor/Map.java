   package editor;

   public class Map{
   
      private String mapName;
      private String mapCode;
      private String BGM;
      private String BGS;
      private int tilesetID;
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
      public int getTilesetID(){
         return tilesetID;
      }
      public void setMapName(String mn){
         mapName = mn;
      }
      public void setMapCode(String mc){
         mapCode = mc;
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
   }