   package editor;
   
   import java.awt.*;
   import java.awt.event.MouseListener;
   import java.awt.event.MouseMotionListener;
   import java.awt.event.MouseEvent;
   import java.awt.event.MouseAdapter;
   
   import java.awt.event.ActionListener;
   import java.awt.event.ActionEvent;
   
   import java.awt.event.KeyListener;
   import java.awt.event.KeyEvent;
	
   import javax.swing.*;
   import javax.swing.JList;
   import javax.swing.border.Border;
   
   import javax.xml.parsers.*;
   import org.xml.sax.Attributes;
   import org.xml.sax.SAXException;
   import org.xml.sax.helpers.DefaultHandler;
	
   import java.io.File;
   import java.util.*;

   public class Editor{
      public static ArrayList<String> mapNameArray = new ArrayList<String>();
      public static ArrayList<Map> mapArray = new ArrayList<Map>();
      public static ArrayList<JLabel> tileArray = new ArrayList<JLabel>();
      
      public static JLabel[][] tileMap;
      
      public static Stack<Change> undoStack = new Stack<Change>();
      public static Stack<Change> redoStack = new Stack<Change>();
   	
      public static JFrame frame;
      public static JPanel listPanel;
      public static JPanel mapPanel;
      public static JPanel tilePanel;
      
      public static JButton saveButton = new JButton("Save");
      public static JButton mapModeButton = new JButton("Map Mode");
      public static JButton NPCModeButton = new JButton("NPC Mode");
      public static JButton pencilButton = new JButton("Pencil");
      public static JButton rectangleButton = new JButton("Rectangle");
      public static JButton fillButton = new JButton("Fill");
      public static JButton selectButton = new JButton("Select");
      
      public static JButton[] buttons = {saveButton, mapModeButton, NPCModeButton, pencilButton, rectangleButton, fillButton, selectButton};
       
      public static int currentTilesetIndex = 0;
      public static int currentMapIndex = -1;
      
      public static boolean mouseDown = false;
      public static int selectedTileID = 0;
      
      public static boolean mapMode = true;
      public static String drawMode = "Pencil";
      
      public static Point rs = new Point(0,0);
      public static Point re = new Point(0,0);
      public static JLabel rsTile;
      public static JLabel reTile;
      
      //Properties stuff
   	
      public static String[] BGMs = {"None", "Stop", "Exceed the Sky.mp3", "Fight Back!.mp3", "P.S.F.mp3", "perkinite panic!!.mp3"};
      public static String[] BGSs = {"None", "Stop"};
      public static String[] tilesets = { "0: Perkins", "1: Power Street" };
   	
      public static Border whiteline = BorderFactory.createCompoundBorder(
      BorderFactory.createLineBorder(Color.black),
      BorderFactory.createLineBorder(Color.white, 2));
      
      public static Border staticwhiteline = BorderFactory.createLineBorder(Color.white, 1);
      
      public enum Properties{
         CHANGE, CREATE
      }
   	
      private static void createAndShowGUI(){
         frame = new JFrame("Perkinites Editor! :)");
         frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
      	
         readMapXML();
      
         Border blackline = BorderFactory.createLineBorder(Color.black);
      
         JPanel toolPanel = new JPanel();
         JPanel leftPanel = new JPanel();
         tilePanel = new JPanel();
         listPanel = new JPanel();
         mapPanel = new JPanel();
      
         toolPanel.setBorder(blackline);
         leftPanel.setBorder(blackline);
         tilePanel.setBorder(blackline);
         listPanel.setBorder(blackline);
         mapPanel.setBorder(blackline);	
         
         
         JTabbedPane tabbedPane = new JTabbedPane();
      
         tabbedPane.addTab("Tiles", null, tilePanel,
                  "Brings up the tileset for this map!");
         tabbedPane.setMnemonicAt(0, KeyEvent.VK_1);
      
         JComponent panel2 = makeTextPanel("Panel #2");
         tabbedPane.addTab("Enemies", null, panel2,
                  "Brings up all the possible enemies!");
         tabbedPane.setMnemonicAt(1, KeyEvent.VK_2);
      
         JComponent panel3 = makeTextPanel("Panel #3");
         tabbedPane.addTab("Doodads", null, panel3,
                  "Brings up all the possible objects!");
         tabbedPane.setMnemonicAt(2, KeyEvent.VK_3);
      	
         frame.setLayout(new BorderLayout());
         frame.add(toolPanel, BorderLayout.PAGE_START);
         frame.add(leftPanel, BorderLayout.LINE_START);
         leftPanel.setLayout(new BorderLayout());      
         leftPanel.add(tabbedPane, BorderLayout.PAGE_START);
         leftPanel.add(listPanel, BorderLayout.CENTER);
         
         
      	
         JScrollPane editorScroll = new JScrollPane(mapPanel);
         frame.add(editorScroll, BorderLayout.CENTER);
         editorScroll.getVerticalScrollBar().setUnitIncrement(16);
         editorScroll.getHorizontalScrollBar().setUnitIncrement(16);
      	
         addToolComps(toolPanel);
         addTileComps(tilePanel);
         addListComps(listPanel);
         addMapComps(mapPanel);	
         
      	
         setupUndoHotkeys();
         
         frame.setFocusable(true);
         frame.pack();
         frame.setSize(640, 480);
         frame.setVisible(true);
      }
      
      public static void addToolComps(JPanel pane){
         pane.add(saveButton);
         pane.add(mapModeButton);
         pane.add(NPCModeButton);
         pane.add(pencilButton);
         pane.add(rectangleButton);
         pane.add(fillButton);
         pane.add(selectButton);
         
         saveButton.addActionListener(new SaveListener());
         
         mapModeButton.setEnabled(false);
         mapModeButton.addActionListener(
               new ActionListener() {
                  public void actionPerformed(ActionEvent e) {
                     mapModeButton.setEnabled(false);
                     NPCModeButton.setEnabled(true);
                     pencilButton.setEnabled(true);
                     rectangleButton.setEnabled(true);
                     fillButton.setEnabled(true);
                     selectButton.setEnabled(true);
                     switch(drawMode){
                        case "Pencil":
                           pencilButton.setEnabled(false);
                           break;
                        case "Rectangle":
                           rectangleButton.setEnabled(false);
                           break;
                        case "Fill":
                           fillButton.setEnabled(false);
                           break;
                        case "Select":
                           selectButton.setEnabled(false);
                           break;
                     
                     }
                     mapMode = true;
                     repaintMap(currentMapIndex);
                  }
               });   
         NPCModeButton.addActionListener(
               new ActionListener() {
                  public void actionPerformed(ActionEvent e) {
                     mapModeButton.setEnabled(true);
                     NPCModeButton.setEnabled(false);
                     pencilButton.setEnabled(false);
                     rectangleButton.setEnabled(false);
                     fillButton.setEnabled(false);
                     selectButton.setEnabled(false);
                     mapMode = false;
                     
                  }
               });   
      	     	
      	
         pencilButton.addActionListener(new DrawListener("Pencil"));
         pencilButton.setEnabled(false);
         rectangleButton.addActionListener(new DrawListener("Rectangle"));
         fillButton.addActionListener(new DrawListener("Fill"));
         selectButton.addActionListener(new DrawListener("Select"));
      }
      public static void addTileComps(JPanel pane){
         pane.removeAll();
         tileArray = new ArrayList<JLabel>();
         pane.setLayout(new GridBagLayout());
         GridBagConstraints c = new GridBagConstraints();
         int numTiles = 0;
         File dir1 = new File(".");
         try {
            numTiles = new File(dir1.getCanonicalPath() + "\\editor\\Tileset"+currentTilesetIndex+"\\").listFiles().length;
         
         } 
            catch (Exception e) {
               e.printStackTrace();
            }
            
         for(int i = 0; i < numTiles; i++){
         
            c.gridx = i%8;
            c.gridy = (int)(i/8);
            JLabel tile = new JLabel(createImageIcon("\\Tileset"+currentTilesetIndex+"\\Tile"+i+".png"));
            tileArray.add(tile);
            tile.addMouseListener(new TileSelectListener(i));
            pane.add(tile, c);
            if(i == selectedTileID){
               tile.setBorder(whiteline);
            }
            else if(i == 0 && selectedTileID >= numTiles){
               tile.setBorder(whiteline);
            }
         }
         
         pane.revalidate();
         pane.repaint();
      }
      static protected JComponent makeTextPanel(String text) {
         JPanel panel = new JPanel(false);
         JLabel filler = new JLabel(text);
         filler.setHorizontalAlignment(JLabel.CENTER);
         panel.setLayout(new GridLayout(1, 1));
         panel.add(filler);
         return panel;
      }
      public static void addListComps(JPanel pane){
         pane.removeAll();
         pane.setLayout(new BorderLayout());
         
         JLabel label = new JLabel("List of Maps :)");
            
         DefaultListModel model = new DefaultListModel();
         final JList list = new JList(model);
      	
         for(int i = 0; i < mapNameArray.size(); i++){
            model.add(i, mapNameArray.get(i));
         }
        
         MouseListener mouseListener = 
            new MouseAdapter(){
               public void mouseClicked(MouseEvent e){
                  if(e.getButton() == 3){
                  
                     int index = list.locationToIndex(e.getPoint());
                     
                     JPopupMenu rcMenu = new JPopupMenu();
                     JMenuItem menuItem;
                  	
                     menuItem = new JMenuItem("Map Properties");
                     menuItem.addActionListener(new PropertiesListener(index, Properties.CHANGE));
                     rcMenu.add(menuItem);
                     menuItem = new JMenuItem("Create New Map");
                     menuItem.addActionListener(new PropertiesListener(mapArray.size(), Properties.CREATE));
                     rcMenu.add(menuItem);
                     menuItem = new JMenuItem("Duplicate");
                     rcMenu.add(menuItem);  
                     menuItem.addActionListener(new DuplicateListener(index));  
                  	
                  
                     rcMenu.show(e.getComponent(),e.getX(), e.getY());
                     list.setSelectedIndex(index);
                  }
                  else if(e.getButton() == 1 &&e.getClickCount() == 2){
                     int index = list.locationToIndex(e.getPoint());
                     loadNewMap(index);
                  }
               }
            };
            
         list.addMouseListener(mouseListener);
         pane.add(label, BorderLayout.PAGE_START);
         pane.add(list, BorderLayout.CENTER);
         
         list.setSelectedIndex(currentMapIndex);
         
         pane.revalidate();
         pane.repaint();
         
      
      }
      public static void addMapComps(JPanel pane){
      
      
      
      }
      
      public static void loadNewMap(int index){
         if(index == currentMapIndex)
            return;
         
         currentMapIndex = index;
         repaintMap(index);
      	
      }
      public static void repaintMap(int index){
         if(currentMapIndex > -1){
            mapPanel.removeAll();
            mapPanel.setLayout(new GridBagLayout());
            GridBagConstraints c = new GridBagConstraints();
         
            Map map = mapArray.get(index);
         
            currentTilesetIndex = map.getTilesetID();
            addTileComps(tilePanel);
            int[][] mapMatrix = map.getMapMatrix();
         
            int row = mapMatrix.length;
            int col = mapMatrix[0].length;
         
         
            tileMap = new JLabel[row][col];
         
         
            for(int i = 0; i < row; i++){
               for(int j = 0; j < col; j++){
                  c.gridx = j;
                  c.gridy = i;
                  JLabel tile = new JLabel(createImageIcon("\\Tileset"+currentTilesetIndex+"\\Tile"+mapMatrix[i][j]+".png")); 
                  tileMap[i][j] = tile;
                  if(mapMode){
                     tile.addMouseListener(new TileListener(j, i, tile, mapMatrix[i][j] ));
                     tile.setBorder(null);
                  }
                  else{
                     tile.addMouseListener(new TileNPCListener(j, i, tile, mapMatrix[i][j] ));	
                  }
                  mapPanel.add(tile, c);
               
               }
            
            }
            mapPanel.getRootPane().revalidate();
            mapPanel.revalidate();
            mapPanel.repaint();
         
         }
      }
      
   	
      protected static ImageIcon createImageIcon(String path){
         java.net.URL imgURL = Editor.class.getResource(path);
         if(imgURL != null){
            return new ImageIcon(imgURL);
         } 
         else{
            System.err.println("Coudn't find: " + path);
            return null;
         }
      }
      
      public static void readMapXML(){
         try{
            SAXParserFactory factory = SAXParserFactory.newInstance();
            SAXParser saxParser = factory.newSAXParser();
            
            DefaultHandler handler = 
               new DefaultHandler(){
               
                  boolean mapName = false;
                  boolean mapCode = false;
                  boolean bgm = false;
                  boolean bgs = false;
                  boolean tilesetID = false;
                  boolean mapID = false;
                  
                  Map map;
                  public void startElement(String uri, String localName, String qName, Attributes attributes) throws SAXException {
                     if(qName.equalsIgnoreCase("Map")){
                        map = new Map();
                     }
                     if(qName.equalsIgnoreCase("MapCode")){
                        mapCode = true;
                     }
                     if(qName.equalsIgnoreCase("MapName")){
                        mapName = true;
                     }
                     if(qName.equalsIgnoreCase("BGM")){
                        bgm = true;
                     }
                     if(qName.equalsIgnoreCase("BGS")){
                        bgs = true;
                     }
                     if(qName.equalsIgnoreCase("MapID")){
                        mapID = true;
                     }
                     if(qName.equalsIgnoreCase("TilesetID")){
                        tilesetID = true;
                     }
                  }
                  public void endElement(String uri, String localName, String qName) throws SAXException {
                     //System.out.println("End Element :" + qName);
                     if(qName.equalsIgnoreCase("Map")){
                        map.createMap();
                        mapArray.add(map);
                      
                     }
                  }
                  public void characters(char ch[], int start, int length) throws SAXException {
                     if(mapCode){
                        map.setMapCode(new String(ch, start, length));
                        mapCode = false;
                     }
                     if(mapName){
                        mapNameArray.add(new String(ch, start, length));
                        map.setMapName(new String(ch, start, length));
                        mapName = false;
                     }
                     if(bgm){
                        map.setBGM(new String(ch, start, length));
                        bgm = false;
                     }
                     if(bgs){
                        map.setBGS(new String(ch, start, length));
                        bgs = false;
                     }
                     if(mapID){
                        map.setMapID(Integer.parseInt(new String(ch, start, length)));
                        mapID = false;
                     }
                     if(tilesetID){
                        map.setTilesetID(Integer.parseInt(new String(ch, start, length)));
                        tilesetID = false;
                     }
                  }
               };
         
            File dir1 = new File(".");
            try {
               saxParser.parse(dir1.getCanonicalPath() + "\\_xml\\Maps.xml", handler);
            } 
               catch (Exception e) {
                  e.printStackTrace();
               }
               
         		
         }
            catch (Exception e){
               e.printStackTrace();
            }
      }
      public static void readNPCXML(){
      }
      public static void createNewMapMenu(){
      
      }
      public static void setupUndoHotkeys() {
         String UNDO = "Undo action key";
         String REDO = "Redo action key";
         Action undoAction = 
            new AbstractAction() {
               public void actionPerformed(ActionEvent e) {
                  undo();
               }
            };
         Action redoAction = 
            new AbstractAction() {
               public void actionPerformed(ActionEvent e) {
                  redo();
               }
            };
      
         frame.getRootPane().getActionMap().put(UNDO, undoAction);
         frame.getRootPane().getActionMap().put(REDO, redoAction);
      
         InputMap[] inputMaps = new InputMap[] {
               frame.getRootPane().getInputMap(JComponent.WHEN_FOCUSED),
               frame.getRootPane().getInputMap(JComponent.WHEN_ANCESTOR_OF_FOCUSED_COMPONENT),
               frame.getRootPane().getInputMap(JComponent.WHEN_IN_FOCUSED_WINDOW),
               };
         for(InputMap i : inputMaps) {
            i.put(KeyStroke.getKeyStroke(KeyEvent.VK_Z, Toolkit.getDefaultToolkit().getMenuShortcutKeyMask()), UNDO);
            i.put(KeyStroke.getKeyStroke(KeyEvent.VK_Y, Toolkit.getDefaultToolkit().getMenuShortcutKeyMask()), REDO);
         }
      }  
      public static void undo(){
         if(undoStack.empty())
            return;
         System.out.println("UNDO");
      
         MapChange c = (MapChange)undoStack.pop();
         redoStack.push(new MapChange(currentMapIndex, mapArray.get(currentMapIndex).getMapMatrix()));
         Map map = mapArray.get(c.getIndex());
         map.setMapMatrix(c.getMapMatrix());
         mapArray.set(c.getIndex(), map);
         if(currentMapIndex == c.getIndex()){
            repaintMap(currentMapIndex);
         }
      
      }
      public static void redo(){
      
         if(redoStack.empty())
            return;
         System.out.println("REDO");
         MapChange c = (MapChange)redoStack.pop();
         undoStack.push(c);
         Map map = mapArray.get(c.getIndex());
         //System.out.println(c.getIndex() + " " + c.getMapCode());
         map.setMapMatrix(c.getMapMatrix());
         mapArray.set(c.getIndex(), map);
         if(currentMapIndex == c.getIndex()){
            repaintMap(currentMapIndex);
         }
      }
   	
   	
   	
      public static void main (String[] args){
         javax.swing.SwingUtilities.invokeLater(
               new Runnable() {
                  public void run(){
                     createAndShowGUI();
                  }
               });
      }   
      
      public static class SaveListener implements ActionListener{
         public void actionPerformed(ActionEvent e){
            MapXMLWriter.writeMapXML(mapArray);
            frame.setFocusable(true);
         }
      }     
      
      public static class DrawListener implements ActionListener{
         private String _mode;
      
         public DrawListener(String mode){
            _mode = mode;
         }
         public void actionPerformed(ActionEvent e){
            pencilButton.setEnabled(true);
            rectangleButton.setEnabled(true);
            fillButton.setEnabled(true);
            selectButton.setEnabled(true);
            
            drawMode = _mode;
            switch(drawMode){
               case "Pencil": 
                  pencilButton.setEnabled(false);
                  break;
               case "Rectangle":
                  rectangleButton.setEnabled(false);
                  break;
               case "Fill":
                  fillButton.setEnabled(false);
                  break;
               case "Select":
                  selectButton.setEnabled(false);
                  break;
            
            }
         }
      }
      public static class TileListener extends MouseAdapter implements MouseMotionListener{
         private int _x;
         private int _y;
         private JLabel _tile;
         private int _tileType;
      
         public TileListener(int xPos, int yPos, JLabel tile, int tileType){
            _x = xPos;
            _y = yPos;
            _tile = tile;
            _tileType = tileType;
         }
         public void mousePressed(MouseEvent e) {
            mouseDown = true;
            undoStack.push(new MapChange(currentMapIndex, mapArray.get(currentMapIndex).getMapMatrix()));
            
            if(drawMode.equals("Pencil")){
               if(_tileType != selectedTileID){
               
                  mapPanel.remove(_tile);
               
                  _tile = new JLabel(createImageIcon("\\Tileset"+currentTilesetIndex+"\\Tile"+selectedTileID+".png"));
                  GridBagConstraints c = new GridBagConstraints();
                  c.gridx = _x;
                  c.gridy = _y;
                  mapPanel.add(_tile, c);
                  mapPanel.getRootPane().revalidate();
                  replaceTile();
                  
               }
            } 
            else if(drawMode.equals("Rectangle")){
               rs = new Point(_x, _y);
               re = new Point(_x, _y);
               rsTile = _tile;
               reTile = _tile;
               _tile.setBorder(whiteline);
               // mapPanel.remove(_tile);
            //    
               // _tile = new JLabel(createImageIcon("\\Tileset"+currentTilesetIndex+"\\Tile"+selectedTileID+".png"));
               // GridBagConstraints c = new GridBagConstraints();
               // c.gridx = _x;
               // c.gridy = _y;
               // mapPanel.add(_tile, c);
               // mapPanel.getRootPane().revalidate();
                  
            }
            else if(drawMode.equals("Fill")){
               if(_tileType != selectedTileID){
                  floodfill(_y, _x, mapArray.get(currentMapIndex));
                  repaintMap(currentMapIndex);
               }
            }
            
         }
      
         public void mouseReleased(MouseEvent e){
            if(drawMode.equals("Rectangle")){
               if(rsTile != null && reTile != null){
                  Map map = mapArray.get(currentMapIndex);
                  rsTile.setBorder(null);
                  reTile.setBorder(null);
                  rsTile = null;
                  reTile = null;
                  int sx; int sy; int ex; int ey;
                  if(rs.x < re.x){
                     sx = rs.x;
                     ex = re.x;
                  }
                  else{
                     sx = re.x;
                     ex = rs.x;
                  }
                  if(rs.y < re.y){
                     sy = rs.y;
                     ey = re.y;
                  }
                  else{
                     sy = re.y;
                     ey = rs.y;
                  }
                     
                  for(int i = sy; i <= ey; i++){
                     for(int j = sx; j <= ex; j++){
                        mapPanel.remove(tileMap[i][j]);
                        GridBagConstraints c = new GridBagConstraints();
                        
                        c.gridx = j;
                        c.gridy = i;
                        JLabel tile = new JLabel(createImageIcon("\\Tileset"+currentTilesetIndex+"\\Tile"+selectedTileID+".png")); 
                        tileMap[i][j] = tile;
                        tile.addMouseListener(new TileListener(j, i, tile, selectedTileID ));
                        tile.setBorder(null);
                        
                        mapPanel.add(tile, c);
                        
                        map.changeTile(i, j, selectedTileID);
                     }
                  }
                  mapArray.set(currentMapIndex, map);
                  mapPanel.revalidate();
                  mapPanel.repaint();
               }
            }
         
            mouseDown = false;
         }
         public void mouseEntered(MouseEvent e){
            if(e.getModifiersEx() != 1024){
               mouseDown = false;
            }
            if(drawMode.equals("Pencil")){
               if(mouseDown){
                  if(_tileType != selectedTileID){
                  
                     mapPanel.remove(_tile);
                  
                     _tile = new JLabel(createImageIcon("\\Tileset"+currentTilesetIndex+"\\Tile"+selectedTileID+".png"));
                     GridBagConstraints c = new GridBagConstraints();
                     c.gridx = _x;
                     c.gridy = _y;
                     mapPanel.add(_tile, c);
                     mapPanel.revalidate();
                     replaceTile();
                  }
               }
            } 
            else if(drawMode.equals("Rectangle")){
               if(mouseDown){
               //create rectangle matrix
                  re = new Point(_x, _y);
                  reTile = _tile;   
                  _tile.setBorder(whiteline);
               
               }
               else{
                  if(rsTile != null && reTile != null){
                     Map map = mapArray.get(currentMapIndex);
                     rsTile.setBorder(null);
                     reTile.setBorder(null);
                     rsTile = null;
                     reTile = null;
                     int sx; int sy; int ex; int ey;
                     if(rs.x < re.x){
                        sx = rs.x;
                        ex = re.x;
                     }
                     else{
                        sx = re.x;
                        ex = rs.x;
                     }
                     if(rs.y < re.y){
                        sy = rs.y;
                        ey = re.y;
                     }
                     else{
                        sy = re.y;
                        ey = rs.y;
                     }
                     
                     for(int i = sy; i <= ey; i++){
                        for(int j = sx; j <= ex; j++){
                           mapPanel.remove(tileMap[i][j]);
                           GridBagConstraints c = new GridBagConstraints();
                        
                           c.gridx = j;
                           c.gridy = i;
                           JLabel tile = new JLabel(createImageIcon("\\Tileset"+currentTilesetIndex+"\\Tile"+selectedTileID+".png")); 
                           tileMap[i][j] = tile;
                           tile.addMouseListener(new TileListener(j, i, tile, selectedTileID ));
                           tile.setBorder(null);
                        
                           mapPanel.add(tile, c);
                        
                           map.changeTile(i, j, selectedTileID);
                        }
                     }
                     mapArray.set(currentMapIndex, map);
                     mapPanel.revalidate();
                     mapPanel.repaint();
                  }
                  
               }
            }
         }
         public void mouseExited(MouseEvent e){
            if(drawMode.equals("Rectangle")){
               if(rs.y != _y || rs.x != _x){
                  _tile.setBorder(null);
               }
            }
         }
         public void mouseDragged(MouseEvent e){
         }
         public void mouseMoved(MouseEvent e){
         }
         
         public void replaceTile(){
            Map map = mapArray.get(currentMapIndex);
            map.changeTile(_y, _x, selectedTileID);
            mapArray.set(currentMapIndex, map);
            _tile.addMouseListener(new TileListener(_x, _y, _tile, selectedTileID ));
            tileMap[_y][_x] = _tile;
         }
         public void floodfill(int r, int c, Map map){
         	
            if(r < 0 || c < 0 || r >= tileMap.length || c >= tileMap[0].length)
               return;
            if(map.getTile(r, c) == selectedTileID || map.getTile(r, c) != _tileType)
               return;
              	
            map.changeTile(r, c, selectedTileID);
            floodfill(r-1, c, map);
            floodfill(r+1, c, map);
            floodfill(r, c-1, map);
            floodfill(r, c+1, map);
         }
         
      }     
      
      public static class TileNPCListener extends MouseAdapter implements MouseMotionListener{
         private int _x;
         private int _y;
         private JLabel _tile;
         private int _tileType;
      
         public TileNPCListener(int xPos, int yPos, JLabel tile, int tileType){
            _x = xPos;
            _y = yPos;
            _tile = tile;
            _tileType = tileType;
         }
         public void mousePressed(MouseEvent e) {
            mouseDown = true;
            _tile.setBorder(whiteline);
         }
         public void mouseReleased(MouseEvent e){
            //System.out.println(e);
            mouseDown = false;
         }
         public void mouseEntered(MouseEvent e){
            if(e.getModifiersEx() != 1024){
               mouseDown = false;
            }
            if(mouseDown){
               _tile.setBorder(whiteline);
            }
         }
         public void mouseExited(MouseEvent e){
            _tile.setBorder(null);
         
         }
         public void mouseDragged(MouseEvent e){
         }
         public void mouseMoved(MouseEvent e){
         }
      }     
   
      public static void trace(String s){
         System.out.println(s);
      }
      public static class PropertiesListener implements ActionListener{
         private int _index;
         private Properties _property;
      
         public PropertiesListener(int index, Properties p){
            _index = index;
            _property = p;
         }
         public void actionPerformed(ActionEvent e){
            Map map;
            
            if(_property == Properties.CHANGE){
               map = mapArray.get(_index);
            }   
            else{
               map = new Map();
            }
         
            JTextField nameField = new JTextField(map.getMapName(), 20);
            JComboBox tilesetList = new JComboBox(tilesets);
            tilesetList.setSelectedIndex(map.getTilesetID());
            JComboBox bgmList = new JComboBox(BGMs);
            JComboBox bgsList = new JComboBox(BGSs);
            
            bgmList.setSelectedIndex(0);
            bgsList.setSelectedIndex(0);
            for(int i = 0; i < BGMs.length; i++){
               if(map.getBGM().equals(BGMs[i])){
                  bgmList.setSelectedIndex(i);
               }
            }
            for(int i = 0; i < BGSs.length; i++){
               if(map.getBGS().equals(BGSs[i])){
                  bgsList.setSelectedIndex(i);
               }
            }
         	
            JTextField widthField = new JTextField(""+map.getWidth(), 3);
            JTextField heightField = new JTextField(""+map.getHeight(), 3);
            JPanel myPanel = new JPanel();  
            myPanel.setLayout(new GridLayout(12, 1));
            myPanel.add(new JLabel("Map Name:"));
            myPanel.add(nameField);
            myPanel.add(new JLabel("Tileset ID:"));
            myPanel.add(tilesetList);   
            myPanel.add(new JLabel("BGM:"));
            myPanel.add(bgmList);
            myPanel.add(new JLabel("BGS: "));
            myPanel.add(bgsList);
            myPanel.add(new JLabel("Width: "));
            myPanel.add(widthField);				
            myPanel.add(new JLabel("Height: "));
            myPanel.add(heightField);		
         	         	
            int result = JOptionPane.showConfirmDialog(null, myPanel, 
               "Map Properties - ID: " + _index, JOptionPane.OK_CANCEL_OPTION);
            if (result == JOptionPane.OK_OPTION) {
               if(!nameField.getText().matches(".*\\w.*")){
                  nameField.setText("BLANK");
               }
               map.setMapName(nameField.getText());
               map.setTilesetID(tilesetList.getSelectedIndex());
               map.setBGM(BGMs[bgmList.getSelectedIndex()]);  
               map.setBGS(BGSs[bgsList.getSelectedIndex()]); 
               int w = map.getWidth();
               int h = map.getHeight();
               if (!widthField.getText().matches("^\\d*$")) {
                  widthField.setText(w+"");
               }  
               if (!heightField.getText().matches("^\\d*$")) {
                  heightField.setText(h+"");
               }  
            	
               int nw = Integer.parseInt(widthField.getText());
               int nh = Integer.parseInt(heightField.getText());
               if(nw < 1){
                  nw = w;
               }
               if(nh < 1){
                  nh = h;
               }
               map.setWidth(nw);
               map.setHeight(nh); 
              
               if(_property == Properties.CHANGE){
                  map.updateMap(h, w);
                  mapArray.set(_index, map);
                  mapNameArray.set(_index, nameField.getText());
               }
               else{
                  map.setMapCode(nh + ":" + nw + ":");
                  map.setMapMatrix(new int[nh][nw]);
                  map.setMapID(_index);
                  mapArray.add(map);
                  mapNameArray.add(nameField.getText());
               }
            
               currentMapIndex = _index;
               currentTilesetIndex = map.getTilesetID();
               addTileComps(tilePanel);
               addListComps(listPanel);
               repaintMap(_index);
            }
         
         }
      }
      
      public static class DuplicateListener implements ActionListener{
         private int _index;
      
         public DuplicateListener(int index){
            _index = index;
         }
         public void actionPerformed(ActionEvent e){
            Map map = new Map();
            Map copiedMap = mapArray.get(_index);
            map.setMapName(copiedMap.getMapName() + " copy");
            map.setMapCode(copiedMap.getMapCode());
            map.setBGM(copiedMap.getBGM());
            map.setBGS(copiedMap.getBGS());
            map.setTilesetID(copiedMap.getTilesetID());
            map.setWidth(copiedMap.getWidth());
            map.setHeight(copiedMap.getHeight());
            int[][] mapMatrix = copiedMap.getMapMatrix();
            int [][] copiedMapMatrix = new int[mapMatrix.length][];
            for(int i = 0; i < mapMatrix.length; i++)
               copiedMapMatrix[i] = mapMatrix[i].clone();
         	
            map.setMapMatrix(copiedMapMatrix);
            
            currentMapIndex = mapArray.size();
            map.setMapID(currentMapIndex);
            mapArray.add(map);
            mapNameArray.add(map.getMapName());
            currentTilesetIndex = map.getTilesetID();
            addTileComps(tilePanel);
            addListComps(listPanel);
            repaintMap(_index);
         }
      
      }
      public static class TileSelectListener extends MouseAdapter {
         private int _index;
      
         public TileSelectListener(int index){
            _index = index;
         }
         public void mousePressed(MouseEvent e) {
            for(int i = 0; i < tileArray.size(); i++){
               tileArray.get(i).setBorder(null);
            }
            tileArray.get(_index).setBorder(whiteline);
            selectedTileID = _index;
         	
         }
         public void mouseEntered(MouseEvent e){
            if(e.getModifiersEx() != 1024){
               return;
            }
            for(int i = 0; i < tileArray.size(); i++){
               tileArray.get(i).setBorder(null);
            }
            tileArray.get(_index).setBorder(whiteline);
            selectedTileID = _index;
         }
      
         public void mouseReleased(MouseEvent e){
         }
      }    
      
   
   }