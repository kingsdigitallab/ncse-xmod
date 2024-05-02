package mining;

import java.io.File;
import java.io.*;
import org.w3c.dom.*;

import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.DocumentBuilder;
import org.xml.sax.SAXException;
import org.xml.sax.SAXParseException;
import org.xml.sax.InputSource;

public class ReadXMLFile {

	private File xmlFile;
	private Node root;
	private Document doc;


    public ReadXMLFile(File _xmlFile, String encoding) throws SAXParseException {
    try {
			xmlFile = _xmlFile;
            DocumentBuilderFactory docBuilderFactory = DocumentBuilderFactory.newInstance();
            
            DocumentBuilder docBuilder = docBuilderFactory.newDocumentBuilder();
            
            InputSource is = new InputSource(new FileInputStream(xmlFile));
            is.setEncoding(encoding);
            
            doc = docBuilder.parse (is);
            // normalize text representation
            doc.getDocumentElement ().normalize ();
			root = doc.getDocumentElement ();
           // System.out.println ("Root element of the doc is " + doc.getDocumentElement().getNodeName());

	}catch (SAXParseException err) {
		
        System.out.println ("** Parsing error" + ", line " 
             + err.getLineNumber () + ", uri " + err.getSystemId ());
        System.out.println(" " + err.getMessage ());
        throw err;
        }catch (SAXException e) {
        Exception x = e.getException ();
        ((x == null) ? e : x).printStackTrace ();

        }catch (Throwable t) {
        t.printStackTrace ();
        }
   
	}

	public String getArticleId(){
		try {
			NodeList listArticleId = doc.getElementsByTagName("ARTID");

			Node ArticleId = listArticleId.item(0);
	
			if (ArticleId.getNodeType() == Node.ELEMENT_NODE){
				Element articleElem = (Element)ArticleId;
				return articleElem.getChildNodes().item(0).getNodeValue().trim();

			}
		
	        }catch (Throwable t) {
	        t.printStackTrace ();
	        } 
			return null;
	}
            
	public String getArticleText(){
			NodeList listArticle = doc.getElementsByTagName("TEXT");
			
			Node text = listArticle.item(0);
			if (text.getNodeType() == Node.ELEMENT_NODE){
				Element textElem = (Element)text;
				return textElem.getChildNodes().item(0).getNodeValue().trim();
				//System.out.println("Article Id : " +textElem.getChildNodes().item(0).getNodeValue().trim());
			}
			return null;
		
	}

	public Node getRoot(){
	
			return root;
	}
			
	public Document getDocument(){
	
			return doc;
	}
		
	public static void main(String[] args) {
	try{
	File xmlFile = new File("/media/Doc/software/GATE/gate-4.0/mining/corpusxmlfaid/EWJ/1858/EWJ-1858-06-01-Ar00104.xml");
    ReadXMLFile docFile = new ReadXMLFile(xmlFile,"ISO-8859-15");
    String docId = docFile.getArticleId();
    System.out.println(docId);
    String docString = docFile.getArticleText();
    System.out.println("str:\n"+docString);
	}catch(Exception e){
		System.out.println(" " + e.getMessage ());
	}
	}
	
}