   package _editor;
   
   import java.lang.reflect.Type;

   import com.google.gson.Gson;
   import com.google.gson.JsonElement;
   import com.google.gson.JsonObject;
   import com.google.gson.JsonParseException;
   import com.google.gson.stream.JsonReader;
   
   import com.google.gson.reflect.TypeToken;

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
   
   import java.io.File;
   
   import java.io.BufferedReader;
   import java.io.FileReader;
   import java.io.FileNotFoundException;
   import java.io.IOException;
   
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
      
      public static Object selectedTileObject = null;
      
      public static JLabel superlabel = new JLabel("I tell you stuff!");
      
      //Properties stuff
   	
      public static String[] BGMs = {"", "Exceed the Sky.mp3", "Fight Back!.mp3", "P.S.F.mp3", "perkinite panic!!.mp3"};
      public static String[] BGSs = {""};
      public static String[] tilesets;
      public static String[] enemies;
   	
      public static Border whiteline = BorderFactory.createCompoundBorder(
      BorderFactory.createLineBorder(Color.black),
      BorderFactory.createLineBorder(Color.white, 2));
      
      public static Border redline = BorderFactory.createCompoundBorder(
      BorderFactory.createLineBorder(Color.black),
      BorderFactory.createLineBorder(Color.red, 2));
      
      public static Border staticwhiteline = BorderFactory.createLineBorder(Color.white, 1);
      
      public enum Properties{
         CHANGE, CREATE
      }
   	
      private static void createAndShowGUI(){
         frame = new JFrame("Perkinites Editor! :)");
         frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
      	
         //readMapXML();
         enemies = MapJSONReader.readEnemyJSON();
         tilesets = MapJSONReader.readTilesetJSON();
         mapArray = MapJSONReader.readMapJSON();
         for(int i = 0; i < mapArray.size(); i++){
            mapNameArray.add(mapArray.get(i).getName());
         }
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
      	
         //setupUndoHotkeys();
         setupDeleteHotkeys();
         
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
                     repaintMap(currentMapIndex);
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
            numTiles = new File(dir1.getCanonicalPath() + "\\_editor\\Tileset_"+tilesets[currentTilesetIndex]+"\\").listFiles().length;
         
         } 
            catch (Exception e) {
               e.printStackTrace();
            }
            
         for(int i = 0; i < numTiles; i++){
         
            c.gridx = i%8;
            c.gridy = (int)(i/8);
            JLabel tile = new JLabel(createImageIcon("\\Tileset_"+tilesets[currentTilesetIndex]+"\\Tile"+i+".png"));
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
         
         pane.add(superlabel, BorderLayout.PAGE_END);
         
         pane.revalidate();
         pane.repaint();
         
      }
      
      public static void loadNewMap(int index){
         if(index == currentMapIndex)
            return;
         
         currentMapIndex = index;
         repaintMap(index);
      	
      }
      public static void repaintMap(int index){
         rs = new Point(-1, -1);
         re = new Point(-1, -1);
         superlabel.setText("I tell you stuff!");
         if(currentMapIndex > -1){
            mapPanel.removeAll();
            mapPanel.setLayout(new GridBagLayout());
            GridBagConstraints c = new GridBagConstraints();
         
            Map map = mapArray.get(index);
            currentTilesetIndex = Arrays.asList(tilesets).indexOf(map.getTileset());
            addTileComps(tilePanel);
            int[][] mapMatrix = map.getMapMatrix();
         
            int row = mapMatrix.length;
            int col = mapMatrix[0].length;
         
         
            tileMap = new JLabel[row][col];
         
         
            for(int i = 0; i < row; i++){
               for(int j = 0; j < col; j++){
                  c.gridx = j;
                  c.gridy = i;
                  JLabel tile =  new JLabel(createImageIcon("\\Tileset_"+tilesets[currentTilesetIndex]+"\\Tile"+mapMatrix[i][j]+".png")); 
                  if(mapMode){   
                     tile.addMouseListener(new TileListener(j, i, tile, mapMatrix[i][j] ));
                  }
                  else{
                     tile.addMouseListener(new TileNPCListener(j, i, tile, mapMatrix[i][j], null));	
                  }
                  tileMap[i][j] = tile;
                  mapPanel.add(tile, c);
               
               }
            
            }
            if(!mapMode){
               ArrayList<Teleport> teleports = map.getTeleports();
               for(int i = 0; i < teleports.size(); i++){
                  Teleport teleport = teleports.get(i);
                  int y = teleport.getEntry().y;
                  int x = teleport.getEntry().x;
                  JLabel tile = tileMap[y][x];
                  mapPanel.remove(tile);
                  Icon teleportIcon = createImageIcon("\\Objects\\teleport.png");
                  Icon tileIcon = createImageIcon("\\Tileset_"+tilesets[currentTilesetIndex]+"\\Tile"+mapMatrix[y][x]+".png");
                
                  tile = new JLabel(new CompoundIcon(CompoundIcon.Axis.Z_AXIS, 0, CompoundIcon.CENTER, CompoundIcon.CENTER, tileIcon, teleportIcon));
                  c.gridx = x;
                  c.gridy = y;
                  mapPanel.add(tile, c);
                  tileMap[y][x] = tile;
                  tile.addMouseListener(new TileNPCListener(x, y, tile, mapMatrix[y][x], teleport));	
               }
            
               ArrayList<Enemy> enemies = map.getEnemies();
               for(int i = 0; i < enemies.size(); i++){
                  Enemy enemy = enemies.get(i);
                  int y = enemy.getPosition().y;
                  int x = enemy.getPosition().x;
                  JLabel tile = tileMap[y][x];
                  mapPanel.remove(tile);
                  Icon enemyIcon = createImageIcon("\\Objects\\enemy.png");
                  Icon tileIcon = createImageIcon("\\Tileset_"+tilesets[currentTilesetIndex]+"\\Tile"+mapMatrix[y][x]+".png");
                
                  tile = new JLabel(new CompoundIcon(CompoundIcon.Axis.Z_AXIS, 0, CompoundIcon.CENTER, CompoundIcon.CENTER, tileIcon, enemyIcon));
                  c.gridx = x;
                  c.gridy = y;
                  mapPanel.add(tile, c);
                  tileMap[y][x] = tile;
                  tile.addMouseListener(new TileNPCListener(x, y, tile, mapMatrix[y][x], enemy));	
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
      public static void setupDeleteHotkeys(){
         String DEL = "Delete action key";
         Action deleteAction = 
            new AbstractAction() {
               public void actionPerformed(ActionEvent e) {
                  deleteObject();
               }
            };
      
         frame.getRootPane().getActionMap().put(DEL, deleteAction);
      
         InputMap[] inputMaps = new InputMap[] {
               frame.getRootPane().getInputMap(JComponent.WHEN_FOCUSED),
               frame.getRootPane().getInputMap(JComponent.WHEN_ANCESTOR_OF_FOCUSED_COMPONENT),
               frame.getRootPane().getInputMap(JComponent.WHEN_IN_FOCUSED_WINDOW),
               };
         for(InputMap i : inputMaps) {
            i.put(KeyStroke.getKeyStroke("DELETE"), DEL);
         }
      }
      public static void deleteObject(){
         if(rs.x != -1 && rs.y != -1 && !mapMode){
            Map map = mapArray.get(currentMapIndex);
            int index = -1;
            if(tileMap[rs.y][rs.x].getIcon() instanceof CompoundIcon){
               TileNPCListener ml = (TileNPCListener)tileMap[rs.y][rs.x].getMouseListeners()[0];
               Object object = ml.getObject();
               if(object instanceof Teleport){
                  ArrayList<Teleport> teleports = map.getTeleports();
                  index = teleports.indexOf((Teleport)object);
                  teleports.remove(index);
                  map.setTeleports(teleports);
                  mapArray.set(currentMapIndex, map);
                  repaintMap(currentMapIndex);
               } 
               else if(object instanceof Enemy){
                  ArrayList<Enemy> es = map.getEnemies();
                  index = es.indexOf((Enemy)object);
                  es.remove(index);
                  map.setEnemies(es);
                  mapArray.set(currentMapIndex, map);
                  repaintMap(currentMapIndex);
               }
               else if(object instanceof NPC){
               
               
               }
            }
         }
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
            for(int i = 0; i < mapArray.size(); i++){
               Map map = mapArray.get(i);
               map.updateMapCode();
               mapArray.set(i, map);
            }
            MapJSONWriter.writeMapJSON(mapArray);
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
            superlabel.setText("(" + _x + ", " + _y + ")");
            if(drawMode.equals("Pencil")){
               if(_tileType != selectedTileID){
               
                  mapPanel.remove(_tile);
               
                  _tile = new JLabel(createImageIcon("\\Tileset_"+tilesets[currentTilesetIndex]+"\\Tile"+selectedTileID+".png"));
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
                        JLabel tile = new JLabel(createImageIcon("\\Tileset_"+tilesets[currentTilesetIndex]+"\\Tile"+selectedTileID+".png")); 
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
            if(mouseDown){
               superlabel.setText("(" + _x + ", " + _y + ")");
            }
            if(drawMode.equals("Pencil")){
               if(mouseDown){
                  if(_tileType != selectedTileID){
                  
                     mapPanel.remove(_tile);
                  
                     _tile = new JLabel(createImageIcon("\\Tileset_"+tilesets[currentTilesetIndex]+"\\Tile"+selectedTileID+".png"));
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
                           JLabel tile = new JLabel(createImageIcon("\\Tileset_"+tilesets[currentTilesetIndex]+"\\Tile"+selectedTileID+".png")); 
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
         private Object _object;
      
         public TileNPCListener(int xPos, int yPos, JLabel tile, int tileType, Object o){
            _x = xPos;
            _y = yPos;
            _tile = tile;
            _tileType = tileType;
            _object = o;
         }
         public Object getObject(){
            return _object;
         }
         public void mousePressed(MouseEvent e) {
            if(e.getClickCount() >= 2){
            
               if(_object == null){
                  choicePopup();
               }
               else if(_object instanceof Teleport){
                  teleportPopup(Properties.CHANGE);
               }
               else if(_object instanceof Enemy){
                  enemyPopup(Properties.CHANGE);
               }
               else if(_object instanceof NPC){
               
               }
            }
            mouseDown = true;
           
            JLabel tile = tileMap[_y][_x];
            if(rs.y != -1 && rs.x != -1)
               tileMap[rs.y][rs.x].setBorder(null);
           
            _tile.setBorder(whiteline);
            rs = new Point(_x, _y);
            re = new Point(_x, _y);
            if(_object == null){
               superlabel.setText("(" + _x + ", " + _y + ")");
            }
            else if(_object instanceof Teleport){
               superlabel.setText("(" + _x + ", " + _y + "): Teleport to " 
                  + ((Teleport)(_object)).getMap() + " (" 
                  + ((Teleport)(_object)).getExit().x + ", "
                  + ((Teleport)(_object)).getExit().y +")" );
            }
            else if(_object instanceof Enemy){
               superlabel.setText("(" + _x + ", " + _y + "): Enemy Type: " 
                  + ((Enemy)(_object)).getID());
            }
            else if(_object instanceof NPC){
               
            }
            selectedTileObject = _object;
         }
         public void mouseReleased(MouseEvent e){
            //System.out.println(e);
            if(selectedTileObject != null && !(tileMap[re.y][re.x].getIcon() instanceof CompoundIcon)){
               Map map = mapArray.get(currentMapIndex);
               int index = -1;
               if(selectedTileObject instanceof Teleport){
                  ArrayList<Teleport> teleports = map.getTeleports();
                  for(int i = 0; i < teleports.size(); i++){
                     if(selectedTileObject == teleports.get(i)){
                        index = i;
                        break;
                     }
                  }
                  
                  ((Teleport)selectedTileObject).setEntry(new Point(re.x, re.y));
                  teleports.set(index, (Teleport)selectedTileObject);
                  map.setTeleports(teleports);
               }
               else if(selectedTileObject instanceof Enemy){
                  ArrayList<Enemy> es = map.getEnemies();
                  for(int i = 0; i < es.size(); i++){
                     if(selectedTileObject == es.get(i)){
                        index = i;
                        break;
                     }
                  }
                  
                  ((Enemy)selectedTileObject).setPosition(new Point(re.x, re.y));
                  es.set(index, (Enemy)selectedTileObject);
                  map.setEnemies(es);
               
               }
               tileMap[rs.y][rs.x].setBorder(null);
               tileMap[re.y][re.x].setBorder(whiteline);
               repaintMap(currentMapIndex);
            }
            mouseDown = false;
         }
         public void mouseEntered(MouseEvent e){
            if(e.getModifiersEx() != 1024){
               mouseDown = false;
            }
            if(mouseDown && selectedTileObject != null){
               if(!(_tile.getIcon() instanceof CompoundIcon))
                  _tile.setBorder(whiteline);
               superlabel.setText("Moving to (" + _x + ", " + _y + ")");
               re = new Point(_x, _y);
            }
         }
         public void mouseExited(MouseEvent e){
            if(rs.x != _x || rs.y != _y){
               tileMap[_y][_x].setBorder(null);
            }
         }
         public void mouseDragged(MouseEvent e){
         }
         public void mouseMoved(MouseEvent e){
         }
         public void choicePopup(){
         
            Object[] possibilities = {"Teleport", "Enemy", "NPC"};
            String s = (String)JOptionPane.showInputDialog(
                    null,
                    "What would you like to make?",
                    "That is SO Raven",
                    JOptionPane.PLAIN_MESSAGE,
               		null,
                    possibilities,
                    "Teleport");
         
         //If a string was returned, say so.
            switch(s){
               case "Teleport":
                  teleportPopup(Properties.CREATE); 
                  break;
               case "Enemy": 
                  enemyPopup(Properties.CREATE);
                  break;
               case "NPC": 
                  break;
            }
            if ((s != null) && (s.length() > 0)) {
               return;
            }
         }
         public void teleportPopup(Properties p){
            int entryX = _x;
            int entryY = _y;
            int exitX = 1;
            int exitY = 1;
            Map map = mapArray.get(currentMapIndex);
            
            if(p == Properties.CHANGE){
               entryX = ((Teleport)_object).getEntry().x;
               entryY = ((Teleport)_object).getEntry().y;
               exitX = ((Teleport)_object).getExit().x;
               exitY = ((Teleport)_object).getExit().y;
            }
            JTextField entryXField = new JTextField(entryX+"", 20);
            JTextField entryYField = new JTextField(entryY+"", 20);
            
            ArrayList<String> mapIDArray = new ArrayList<String>();
            for(int i = 0; i < mapArray.size(); i++){
               mapIDArray.add(mapArray.get(i).getID());
            }
            JComboBox mapList = new JComboBox(mapIDArray.toArray());
            if(p == Properties.CHANGE){
               mapList.setSelectedIndex( mapIDArray.indexOf( ((Teleport)_object).getMap()));
            }
            else if(p == Properties.CREATE){
               mapList.setSelectedIndex(0);
            }
            JTextField exitXField = new JTextField(exitX+"", 20);
            JTextField exitYField = new JTextField(exitY+"", 20);
            
         	
            JPanel myPanel = new JPanel();  
            myPanel.setLayout(new GridLayout(10, 1));
            myPanel.add(new JLabel("Entry X:"));
            myPanel.add(entryXField);
            myPanel.add(new JLabel("Entry Y:"));
            myPanel.add(entryYField);
            myPanel.add(new JLabel("Map Destination:"));
            myPanel.add(mapList);   
            myPanel.add(new JLabel("Exit X:"));
            myPanel.add(exitXField);
            myPanel.add(new JLabel("Exit Y:"));
            myPanel.add(exitYField);
                    	         	
            int result = JOptionPane.showConfirmDialog(null, myPanel, 
               "Teleport Properties", JOptionPane.OK_CANCEL_OPTION);
            if (result == JOptionPane.OK_OPTION) {
             
               if (!entryXField.getText().matches("^\\d*$") || entryXField.getText().length() == 0) {
                  entryXField.setText(entryX+"");
               }  
               if (!entryYField.getText().matches("^\\d*$") || entryYField.getText().length() == 0) {
                  entryYField.setText(entryY+"");
               }  
               if (!exitXField.getText().matches("^\\d*$") || exitXField.getText().length() == 0) {
                  exitXField.setText(exitX+"");
               }  
               if (!exitYField.getText().matches("^\\d*$") || exitYField.getText().length() == 0) {
                  exitYField.setText(exitY+"");
               }  
            	
               int eX1 = Integer.parseInt(entryXField.getText());
               int eY1 = Integer.parseInt(entryYField.getText());
               int eX2 = Integer.parseInt(exitXField.getText());
               int eY2 = Integer.parseInt(exitYField.getText());
               if(eX1 < 0 || eX1 >= tileMap[0].length){
                  eX1 = entryX;
               }
               if(eY1 < 0 || eY1 >= tileMap.length){
                  eY1 = entryY;
               }
               
               int[][] exitMapMatrix = mapArray.get(mapList.getSelectedIndex()).getMapMatrix();
               System.out.println(exitMapMatrix[0].length + " " + exitMapMatrix.length);
               if(eX2 < 0 || eX2 >=  exitMapMatrix[0].length){
                  eX2 = exitX;
               }
               if(eY2 < 0 || eY2 >= exitMapMatrix.length){
                  eY2 = exitY;
               }
            
               ArrayList<Teleport> teleports = map.getTeleports();   
               int index = -1;
               if(p == Properties.CHANGE){
                  for(int i = 0; i < teleports.size(); i++){
                     if(_object == teleports.get(i)){
                        index = i;
                        break;
                     }
                  }
               }
               else if(p == Properties.CREATE){
                  index = teleports.size();
                  _object = new Teleport(null, null, null);
                  teleports.add((Teleport)_object);
               }
               ((Teleport)_object).setEntry(new Point(eX1, eY1));
               ((Teleport)_object).setMap(mapIDArray.get(mapList.getSelectedIndex()));
               ((Teleport)_object).setExit(new Point(eX2, eY2));
               teleports.set(index, (Teleport)_object);
               map.setTeleports(teleports);
               
               repaintMap(currentMapIndex);
            }
         }
         public void enemyPopup(Properties p){
            int x = _x;
            int y = _y;
            Map map = mapArray.get(currentMapIndex);
            
            JComboBox enemyList = new JComboBox(enemies);
            if(p == Properties.CHANGE){
               enemyList.setSelectedIndex( Arrays.asList(enemies).indexOf( ((Enemy)_object).getID()));
            }
            else if(p == Properties.CREATE){
               enemyList.setSelectedIndex(0);
            }
            
            JTextField xField = new JTextField(x+"", 20);
            JTextField yField = new JTextField(y+"", 20);
            
         	
            JPanel myPanel = new JPanel();  
            myPanel.setLayout(new GridLayout(6, 1));
            myPanel.add(new JLabel("Enemy ID:"));
            myPanel.add(enemyList);   
            myPanel.add(new JLabel("X:"));
            myPanel.add(xField);
            myPanel.add(new JLabel("Y:"));
            myPanel.add(yField);
                    	         	
            int result = JOptionPane.showConfirmDialog(null, myPanel, 
               "Enemy Properties", JOptionPane.OK_CANCEL_OPTION);
            if (result == JOptionPane.OK_OPTION) {
             
               if (!xField.getText().matches("^\\d*$") || xField.getText().length() == 0) {
                  xField.setText(x+"");
               }  
               if (!yField.getText().matches("^\\d*$") || yField.getText().length() == 0) {
                  yField.setText(y+"");
               }  
            	
               int x1 = Integer.parseInt(xField.getText());
               int y1 = Integer.parseInt(yField.getText());
               if(x1 < 0 || x1 >= tileMap[0].length){
                  x1 = x;
               }
               if(y1 < 0 || y1 >= tileMap.length){
                  y1 = y;
               }
               
            
               ArrayList<Enemy> es= map.getEnemies();   
               int index = -1;
               if(p == Properties.CHANGE){
                  for(int i = 0; i < es.size(); i++){
                     if(_object == es.get(i)){
                        index = i;
                        break;
                     }
                  }
               }
               else if(p == Properties.CREATE){
                  index = es.size();
                  _object = new Enemy(null, null);
                  es.add((Enemy)_object);
               }
               ((Enemy)_object).setID(enemies[(enemyList.getSelectedIndex())]);
               ((Enemy)_object).setPosition(new Point(x1, y1));
               es.set(index, (Enemy)_object);
               map.setEnemies(es);
               
               repaintMap(currentMapIndex);
            }
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
         
            JTextField nameField = new JTextField(map.getName(), 20);
            JTextField idField = new JTextField(map.getID(), 20);
            JComboBox tilesetList = new JComboBox(tilesets);
            tilesetList.setSelectedIndex(Arrays.asList(tilesets).indexOf(map.getTileset()));
            JComboBox bgmList = new JComboBox(BGMs);
            JComboBox bgsList = new JComboBox(BGSs);
            
            tilesetList.setSelectedIndex(currentTilesetIndex);
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
            myPanel.setLayout(new GridLayout(14, 1));
            myPanel.add(new JLabel("Map Name:"));
            myPanel.add(nameField);
            myPanel.add(new JLabel("Map ID:"));
            myPanel.add(idField);
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
               map.setName(nameField.getText());
               if(!idField.getText().matches(".*\\w.*")){
                  nameField.setText("blank");
               }
               map.setID(idField.getText());
               map.setTileset(tilesets[tilesetList.getSelectedIndex()]);
               map.setBGM(BGMs[bgmList.getSelectedIndex()]);  
               map.setBGS(BGSs[bgsList.getSelectedIndex()]); 
               int w = map.getWidth();
               int h = map.getHeight();
               if (!widthField.getText().matches("^\\d*$") || widthField.getText().length() == 0) {
                  widthField.setText(w+"");
               }  
               if (!heightField.getText().matches("^\\d*$") || heightField.getText().length() == 0) {
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
                  map.setMapMatrix(new int[nh][nw]);
                  mapArray.add(map);
                  mapNameArray.add(nameField.getText());
               }
            
               currentMapIndex = _index;
               currentTilesetIndex = Arrays.asList(tilesets).indexOf(map.getTileset());
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
            map.setName(copiedMap.getName() + " copy");
            map.setID(copiedMap.getID() + "_copy");
            map.setTileset(copiedMap.getTileset());
            map.setHeight(copiedMap.getHeight());
            map.setWidth(copiedMap.getWidth());
            map.setCode(copiedMap.getCode());
            map.setBGM(copiedMap.getBGM());
            map.setBGS(copiedMap.getBGS());
            int[][] mapMatrix = copiedMap.getMapMatrix();
            int [][] copiedMapMatrix = new int[mapMatrix.length][];
            for(int i = 0; i < mapMatrix.length; i++)
               copiedMapMatrix[i] = mapMatrix[i].clone();
         	
            map.setMapMatrix(copiedMapMatrix);
            
            currentMapIndex = mapArray.size();
            mapArray.add(map);
            mapNameArray.add(map.getName());
            currentTilesetIndex = Arrays.asList(tilesets).indexOf(map.getTileset());
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