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
	
   import java.util.*;
	
   public class Editor{
   
      public static ArrayList<String> mapNameArray = new ArrayList<String>();
      public static ArrayList<Map> mapArray = new ArrayList<Map>();
      public static ArrayList<JLabel> tileArray = new ArrayList<JLabel>();
      
      public static Stack<Change> undoStack = new Stack<Change>();
      public static Stack<Change> redoStack = new Stack<Change>();
   	
      public static JFrame frame;
      public static JPanel listPanel;
      public static JPanel mapPanel;
      public static int currentMapIndex = -1;
      
      public static boolean mouseDown = false;
      public static char shortcutChar = '0';
      
      public static String drawMode = "Pencil";
      
      
      public static Border whiteline = BorderFactory.createCompoundBorder(
      BorderFactory.createLineBorder(Color.black),
      BorderFactory.createLineBorder(Color.white, 2));
      
      private static void createAndShowGUI(){
         frame = new JFrame("Perkinites Map/NPC Editor! :)");
         frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
      	
         readMapXML();
      
         Border blackline = BorderFactory.createLineBorder(Color.black);
      
         JPanel toolPanel = new JPanel();
         JPanel leftPanel = new JPanel();
         JPanel tilePanel = new JPanel();
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
         
      
      
         // Action escapeAction = 
            // new AbstractAction() {
               // public void actionPerformed(ActionEvent e) {
               // //close the frame
               // System.out.println("okay");
               // }
            // };
         // frame.getRootPane().getInputMap(JComponent.WHEN_IN_FOCUSED_WINDOW).put(KeyStroke.getKeyStroke("F2"),
            //                 "doSomething");
         // frame.getRootPane().getActionMap().put("doSomething",
            //                  escapeAction);
         //frame.addKeyListener(new ShortcutListener());
         // toolPanel.addKeyListener(new ShortcutListener());
         // leftPanel.addKeyListener(new ShortcutListener());
         // listPanel.addKeyListener(new ShortcutListener());
         // mapPanel.addKeyListener(new ShortcutListener());
         
      	
         setupUndoHotkeys();
         
         frame.setFocusable(true);
         frame.pack();
         frame.setSize(640, 480);
         frame.setVisible(true);
      }
      
      public static void addToolComps(JPanel pane){
         JButton saveButton = new JButton("Save");
         JButton mapModeButton = new JButton("Map Mode");
         JButton NPCModeButton = new JButton("NPC Mode");
         JButton pencilButton = new JButton("Pencil");
         JButton rectangleButton = new JButton("Rectangle");
         JButton fillButton = new JButton("Fill");
         JButton selectButton = new JButton("Select");
      
         pane.add(saveButton);
         pane.add(mapModeButton);
         pane.add(NPCModeButton);
         pane.add(pencilButton);
         pane.add(rectangleButton);
         pane.add(fillButton);
         pane.add(selectButton);
         
         saveButton.addActionListener(new SaveListener());
         
         pencilButton.addActionListener(new DrawListener("Pencil"));
         pencilButton.setEnabled(false);
         rectangleButton.addActionListener(new DrawListener("Rectangle"));
         fillButton.addActionListener(new DrawListener("Fill"));
         selectButton.addActionListener(new DrawListener("Select"));
      }
      public static void addTileComps(JPanel pane){
         tileArray = new ArrayList<JLabel>();
         pane.setLayout(new GridBagLayout());
         GridBagConstraints c = new GridBagConstraints();
      
         for(int i = 0; i < 7; i++){
         
            c.gridx = i;
            c.gridy = (int)(i/8);
            JLabel tile = new JLabel(createImageIcon("\\Tileset0\\Tile"+i+".png"));
            tileArray.add(tile);
            tile.addMouseListener(new TileSelectListener(i));
            pane.add(tile, c);
            if(i == 0){
               tile.setBorder(whiteline);
            }
         }
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
                     menuItem.addActionListener(new PropertiesListener(index));
                     rcMenu.add(menuItem);
                     menuItem = new JMenuItem("Create New Map");
                     //menuItem.addActionListener(this);
                     rcMenu.add(menuItem);
                     menuItem = new JMenuItem("Duplicate");
                     rcMenu.add(menuItem);  
                     menuItem = new JMenuItem("Delete");
                     //menuItem.addActionListener(this);
                     rcMenu.add(menuItem);  
                  	
                  
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
         
         pane.revalidate();
         
      
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
         mapPanel.removeAll();
         mapPanel.setLayout(new GridBagLayout());
         GridBagConstraints c = new GridBagConstraints();
         
         Map map = mapArray.get(index);
         String mapCode = map.getMapCode();
         System.out.println(mapArray.get(index).getMapName());
         int index1 = mapCode.indexOf(":");
         int index2 = mapCode.indexOf(":", index1+1);
         int index3 = index2 + 1;
         int row = Integer.parseInt(mapCode.substring(0, index1));
         int col = Integer.parseInt(mapCode.substring(index1+1, index2));
         for(int i = 0; i < row; i++){
            for(int j = 0; j < col; j++){
               c.gridx = j;
               c.gridy = i;
               JLabel tile = new JLabel(createImageIcon("\\Tileset0\\Tile"+mapCode.substring(index3, index3+1)+".png")); 
               tile.addMouseListener(new TileListener(j, i, tile, mapCode.charAt(index3) ));
               mapPanel.add(tile, c);
               index3++;
            }
         }
         
         mapPanel.getRootPane().revalidate();
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
                  }
                  public void endElement(String uri, String localName, String qName) throws SAXException {
                     //System.out.println("End Element :" + qName);
                     if(qName.equalsIgnoreCase("Map")){
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
                  }
               };
         
            saxParser.parse("C:\\Projects\\Games\\Flash Games\\Perkinites v2\\_xml\\Maps.xml", handler);
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
         System.out.println("UNDO");
         if(undoStack.empty())
            return;
         MapChange c = (MapChange)undoStack.pop();
         
         redoStack.push(new MapChange(currentMapIndex, mapArray.get(currentMapIndex).getMapCode()));
         Map map = mapArray.get(c.getIndex());
         map.setMapCode(c.getMapCode());
         mapArray.set(c.getIndex(), map);
         if(currentMapIndex == c.getIndex()){
            repaintMap(currentMapIndex);
         }
      
      }
      public static void redo(){
         System.out.println("REDO");
         if(redoStack.empty())
            return;
         MapChange c = (MapChange)redoStack.pop();
         undoStack.push(c);
         Map map = mapArray.get(c.getIndex());
         System.out.println(c.getIndex() + " " + c.getMapCode());
         map.setMapCode(c.getMapCode());
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
            drawMode = _mode;
         }
      }
      public static class TileListener extends MouseAdapter implements MouseMotionListener{
         private int _x;
         private int _y;
         private JLabel _tile;
         private char _tileType;
      
         public TileListener(int xPos, int yPos, JLabel tile, char tileType){
            _x = xPos;
            _y = yPos;
            _tile = tile;
            _tileType = tileType;
         }
         public void mousePressed(MouseEvent e) {
         
            System.out.println(e);
            undoStack.push(new MapChange(currentMapIndex, mapArray.get(currentMapIndex).getMapCode()));
            mouseDown = true;
            
            if(_tileType != shortcutChar){
            
               mapPanel.remove(_tile);
            
               _tile = new JLabel(createImageIcon("\\Tileset0\\Tile"+shortcutChar+".png"));
               GridBagConstraints c = new GridBagConstraints();
               c.gridx = _x;
               c.gridy = _y;
               mapPanel.add(_tile, c);
               mapPanel.getRootPane().revalidate();
               replaceTile();
            }
         }
         public void mouseReleased(MouseEvent e){
            System.out.println(e);
            mouseDown = false;
         }
         public void mouseEntered(MouseEvent e){
            if(e.getModifiersEx() != 1024){
               mouseDown = false;
            }
            if(mouseDown){
               if(_tileType != shortcutChar){
               
                  mapPanel.remove(_tile);
               
                  _tile = new JLabel(createImageIcon("\\Tileset0\\Tile"+shortcutChar+".png"));
                  GridBagConstraints c = new GridBagConstraints();
                  c.gridx = _x;
                  c.gridy = _y;
                  mapPanel.add(_tile, c);
                  mapPanel.revalidate();
                  replaceTile();
                  
               }
            }
         }
         public void mouseDragged(MouseEvent e){
            System.out.println("whee");
         }
         public void mouseMoved(MouseEvent e){
         }
         
         public void replaceTile(){
            Map map = mapArray.get(currentMapIndex);
            String mapCode = map.getMapCode();
            int index1 = mapCode.indexOf(":");
            int index2 = mapCode.indexOf(":", index1+1);
            int index3 = index2+1;
            int row = Integer.parseInt(mapCode.substring(0, index1));
            int col = Integer.parseInt(mapCode.substring(index1+1, index2));
            
            index3 = index3 + col*_y + _x; 
            mapCode = mapCode.substring(0, index3) + shortcutChar + mapCode.substring(index3+1, mapCode.length());
            map.setMapCode(mapCode);
            mapArray.set(currentMapIndex, map);
            
            _tile.addMouseListener(new TileListener(_x, _y, _tile, mapCode.charAt(index3) ));
         
         }
         
      }     
      public static void trace(String s){
         System.out.println(s);
      }
      public static class PropertiesListener implements ActionListener{
         private int _index;
      
         public PropertiesListener(int index){
            _index = index;
         }
         public void actionPerformed(ActionEvent e){
            Map map = mapArray.get(_index);
            
            JTextField nameField = new JTextField(map.getMapName(), 20);
            JTextField bgmField = new JTextField(map.getBGM(), 20);
            JTextField bgsField = new JTextField(map.getBGS(), 20);
            JTextField widthField = new JTextField(""+map.getWidth(), 3);
            JTextField heightField = new JTextField(""+map.getHeight(), 3);
            JPanel myPanel = new JPanel();  
            myPanel.setLayout(new GridLayout(10, 1));
            myPanel.add(new JLabel("Map Name:"));
            myPanel.add(nameField);
            myPanel.add(new JLabel("BGM:"));
            myPanel.add(bgmField);
            myPanel.add(new JLabel("BGS: "));
            myPanel.add(bgsField);
            myPanel.add(new JLabel("Width: "));
            myPanel.add(widthField);				
            myPanel.add(new JLabel("Height: "));
            myPanel.add(heightField);		
         	         	
            int result = JOptionPane.showConfirmDialog(null, myPanel, 
               "Map Properties - ID: " + _index, JOptionPane.OK_CANCEL_OPTION);
            if (result == JOptionPane.OK_OPTION) {
               System.out.println("yeah");
               map.setMapName(nameField.getText());
               map.setBGM(bgmField.getText());  
               map.setBGS(bgsField.getText()); 
               int w = map.getWidth();
               int h = map.getHeight();
               int nw = Integer.parseInt(widthField.getText());
               int nh = Integer.parseInt(heightField.getText());
               if(w != nw){
               }
               if(h != nh){
               }
               map.setWidth(nw);
               map.setHeight(nh); 
            	
            	
               mapArray.set(_index, map);
               mapNameArray.set(_index, nameField.getText());
               addListComps(listPanel);
            }
         
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
            shortcutChar = Integer.toString(_index).charAt(0);
         	
         }
         public void mouseEntered(MouseEvent e){
            if(e.getModifiersEx() != 1024){
               return;
            }
            for(int i = 0; i < tileArray.size(); i++){
               tileArray.get(i).setBorder(null);
            }
            tileArray.get(_index).setBorder(whiteline);
            shortcutChar = Integer.toString(_index).charAt(0);
         }
      
         public void mouseReleased(MouseEvent e){
         }
      }     
   
   }