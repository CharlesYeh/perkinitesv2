   package editor;

   public class Map{
   
      private int[][] _mapMatrix;
      
      private String _mapName;
      private String _mapCode;
      private String _BGM;
      private String _BGS;
      private int _mapID;
      private int _tilesetID;
      private int _width;
      private int _height;
      public Map(){
         _BGM = "None";
         _BGS = "None";
         _tilesetID = 0;
         _width = 20;
         _height = 15;
      }
      public String getMapName(){
         return _mapName;
      }
      public String getMapCode(){
         return _mapCode;
      }
      public String getBGM(){
         return _BGM;
      }
      public String getBGS(){
         return _BGS;
      }
      public int getWidth(){
         return _width;
      }
      public int getHeight(){
         return _height;
      }
      public int getTilesetID(){
         return _tilesetID;
      }
      public int getMapID(){
         return _mapID;
      }
      public int[][] getMapMatrix(){
         return _mapMatrix;
      }
      public void setMapName(String mn){
         _mapName = mn;
      }
      public void setMapCode(String mc){
         _mapCode = mc;
         int index1 = _mapCode.indexOf(":");
         int index2 = _mapCode.indexOf(":", index1+1);
         _height = Integer.parseInt(_mapCode.substring(0, index1));
         _width = Integer.parseInt(_mapCode.substring(index1+1, index2));
      }
      public void setMapMatrix(int[][] mm){
         _mapMatrix = mm;
         
      }
      public void setBGM(String bgm){
         _BGM = bgm;
      }
      public void setBGS(String bgs){
         _BGS = bgs;
      }
      public void setTilesetID(int tID){
         _tilesetID = tID;
      }
      public void setWidth(int w){
         _width = w;
         // int index1 = _mapCode.indexOf(":");
         // int index2 = _mapCode.indexOf(":", index1+1);
         // _mapCode = _mapCode.substring(0, index1+1) + _width + _mapCode.substring(index2);
      }
      public void setHeight(int h){
         _height = h;
         // int index1 = _mapCode.indexOf(":");
         // int index2 = _mapCode.indexOf(":", index1+1);
         // _mapCode = _height + _mapCode.substring(index1);
      }
      public void setMapID(int mID){
      _mapID = mID;
      }
   	/*
   	 * Creates the initial map before any edits. Everything besides mapMatrix should be filled in already.
   	 */
      public void createMap(){
         _mapMatrix = new int[_height][_width];
      
         int index1 = _mapCode.indexOf(":");
         int index2 = _mapCode.indexOf(":", index1+1);
         int index3 = index2 + 1;
         int row = Integer.parseInt(_mapCode.substring(0, index1));
         int col = Integer.parseInt(_mapCode.substring(index1+1, index2));
         for(int i = 0; i < row; i++){
            for(int j = 0; j < col; j++){
               String tileID = _mapCode.substring(index3, index3+1);
            //check if substring is a letter or not
               if(Character.isLetter(tileID.charAt(0))){
                  _mapMatrix[i][j] = tileID.charAt(0) - 55;
               }
               else{
               //if not
                  _mapMatrix[i][j] = Integer.parseInt(tileID);
               }
               index3++;
            }
         }
      }
      
      /*
   	 * Changes the map to account for width/height changes.
   	 */  
      public void updateMap(int oldHeight, int oldWidth){
         int[][] temp = new int[_height][_width];
         int row;
         int col;
         if(_height < oldHeight){
            row = _height;
         }
         else{
            row = oldHeight;
         }
         if(_width < oldWidth){
            col = _width;
         }
         else{
            col = oldWidth;
         }
         
         for(int i = 0; i < _height; i++){
            for(int j = 0; j < _width; j++){
               temp[i][j] = 0;
            }
         }
         for(int i = 0; i < row; i++){
            for(int j = 0; j < col; j++){
               temp[i][j] = _mapMatrix[i][j];
            }
         }
         
         _mapMatrix = temp;
      }
      
      public void updateMapCode(){
         int index1 = _mapCode.indexOf(":");
         int index2 = _mapCode.indexOf(":", index1+1);
         int index3 = index2 + 1;
         int row = Integer.parseInt(_mapCode.substring(0, index1));
         int col = Integer.parseInt(_mapCode.substring(index1+1, index2));
         for(int i = 0; i < row; i++){
            for(int j = 0; j < col; j++){
               index3++;
            }
         }
         
         String addOn = _mapCode.substring(index3);
      
      	
      	
         _mapCode = _height + ":" + _width + ":";
         for(int i = 0; i < _height; i++){
            for(int j = 0; j < _width; j++){
               if(_mapMatrix[i][j] >= 10){
                  _mapCode+= (char)(_mapMatrix[i][j]+55);
               }
               else{
                  _mapCode += _mapMatrix[i][j];
               }
               
            }
         }
         _mapCode+=addOn;
      
      }
      
      public void changeTile(int r, int c, int tileID){
         _mapMatrix[r][c] = tileID;
      }
      
      public void printMap(){
         int index1 = _mapCode.indexOf(":");
         int index2 = _mapCode.indexOf(":", index1+1);
         int index3 = index2 + 1;
         int row = Integer.parseInt(_mapCode.substring(0, index1));
         int col = Integer.parseInt(_mapCode.substring(index1+1, index2));
         for(int i = 0; i < row; i++){
            for(int j = 0; j < col; j++){
               System.out.print(_mapMatrix[i][j]);
            }
            System.out.println();
         }
      
      }
   	
   }