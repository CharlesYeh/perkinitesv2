   package editor;

   import java.io.File;
   import java.util.ArrayList;
	
   import javax.xml.parsers.DocumentBuilder;
   import javax.xml.parsers.DocumentBuilderFactory;
   import javax.xml.parsers.ParserConfigurationException;
   import javax.xml.transform.Transformer;
   import javax.xml.transform.TransformerException;
   import javax.xml.transform.TransformerFactory;
   import javax.xml.transform.dom.DOMSource;
   import javax.xml.transform.stream.StreamResult;
   import javax.xml.transform.OutputKeys;
 
   import org.w3c.dom.Attr;
   import org.w3c.dom.Document;
   import org.w3c.dom.Element;
   
   public class MapXMLWriter{
   
      public static void writeMapXML(ArrayList<Map> mapArray) {
      
         try {
         
            DocumentBuilderFactory docFactory = DocumentBuilderFactory.newInstance();
            DocumentBuilder docBuilder = docFactory.newDocumentBuilder();
         
         // root elements
            Document doc = docBuilder.newDocument();
            Element rootElement = doc.createElement("Maps");
            doc.appendChild(rootElement);
         
            for(int i = 0; i < mapArray.size(); i++){
               Map map = mapArray.get(i);
            // map elements
               Element mapE = doc.createElement("Map");
               rootElement.appendChild(mapE);
            
            // ID element
               Element idE = doc.createElement("ID");
               //idE.appendChild(doc.createTextNode(i));
               mapE.appendChild(idE);
               
            // map code element
               Element mapCodeE = doc.createElement("MapCode");
               mapCodeE.appendChild(doc.createTextNode(map.getMapCode()));
               mapE.appendChild(mapCodeE);
            	
            // map name element
               Element mapNameE = doc.createElement("MapName");
               mapNameE.appendChild(doc.createTextNode(map.getMapName()));
               mapE.appendChild(mapNameE);
               
            // tilesetID element
               Element tilesetIDE = doc.createElement("TilesetID");
               tilesetIDE.appendChild(doc.createTextNode(""+map.getTilesetID()));          
            	//tilesetIDE.appendChild(doc.createTextNode(map.getMapName()));
               mapE.appendChild(tilesetIDE);
            
            // BGM element
               Element bgmE = doc.createElement("BGM");
               bgmE.appendChild(doc.createTextNode(map.getBGM()));
               mapE.appendChild(bgmE);
               
            // BGS element
               Element bgsE = doc.createElement("BGS");
               bgsE.appendChild(doc.createTextNode(map.getBGS()));
               mapE.appendChild(bgsE);
               
            // NPCs element
               Element npcsE = doc.createElement("NPCs");
               //npcsE.appendChild(doc.createTextNode(map.getMapName()));
               mapE.appendChild(npcsE);
            // // set attribute to staff element
               // Attr attr = doc.createAttribute("id");
               // attr.setValue("1");
               // staff.setAttributeNode(attr);
            // 
            // // shorten way
            // // staff.setAttribute("id", "1");
            // 
            
            }
                 
         // write the content into xml file
            TransformerFactory transformerFactory = TransformerFactory.newInstance();
            Transformer transformer = transformerFactory.newTransformer();
            transformer.setOutputProperty(OutputKeys.INDENT, "yes");
            transformer.setOutputProperty("{http://xml.apache.org/xslt}indent-amount", "2");
            DOMSource source = new DOMSource(doc);
            StreamResult result = new StreamResult(new File("C:\\Projects\\Games\\Flash Games\\Perkinites v2\\_xml\\Maps_c.xml"));
         
         // Output to console for testing
         // StreamResult result = new StreamResult(System.out);
         
            transformer.transform(source, result);
         
            System.out.println("File saved!");
         
         } 
            catch (ParserConfigurationException pce) {
               pce.printStackTrace();
            } 
            catch (TransformerException tfe) {
               tfe.printStackTrace();
            }
      }
   }