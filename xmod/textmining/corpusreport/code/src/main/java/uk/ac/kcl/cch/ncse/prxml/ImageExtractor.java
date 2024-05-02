package uk.ac.kcl.cch.ncse.prxml;

import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.Enumeration;
import java.util.Set;
import java.util.TreeSet;
import java.util.zip.ZipEntry;
import java.util.zip.ZipFile;

import org.xml.sax.Attributes;
import org.xml.sax.InputSource;
import org.xml.sax.SAXException;
import org.xml.sax.XMLReader;
import org.xml.sax.helpers.DefaultHandler;
import org.xml.sax.helpers.XMLReaderFactory;

public class ImageExtractor {
	
	private InputStream article;
	private ZipFile zip;
	private String path;
	private String filename;
	private String id;

	public ImageExtractor(InputStream article, ZipFile zip, String path){
		this.article = article;
		this.zip = zip;
		this.path = path;
		init();
	}
	
	public InputStream getSnippetInputStream(){
		try {
			String imageFileName = getSnippetFileName();
			String location = path+"/Img/"+imageFileName;
			ZipEntry zipEntry = zip.getEntry(location);
			return zip.getInputStream(zipEntry);
		}
		catch (IOException e) {
			return null;
		}
	}
	
	public String getSnippetFileName(){
		return filename;
	}

	private void init(){
		ArticleInfoExtractor h = new ArticleInfoExtractor();
		try {
			XMLReader parser = XMLReaderFactory.createXMLReader();
			parser.setContentHandler(h);
			parser.setErrorHandler(h);
			parser.parse(new InputSource(new InputStreamReader(article)));
			id = h.getId();
			
			filename = h.getFileName();
		}
		catch(SAXException e) {
			// TODO: LOG
		}
		catch (IOException e) {
			
		}
	}
	
	private static class ArticleInfoExtractor extends DefaultHandler {
		private String fileName;
		private String id;
		public void startElement(String uri, String localName, String qName, Attributes attributes) throws SAXException {
			if ("XMD-entity".equals(localName)){
				fileName = attributes.getValue("SNP");
				id =  attributes.getValue("ID");
			}
		}
		public String getFileName(){
			return fileName;
		}
		public String getId(){
			return id;
		}
	}


	public InputStream getImageInputStream(String imageFilename) {
		try {
			String target = path+"/Img/"+imageFilename;
			ZipEntry zipEntry = zip.getEntry(target);
			return zip.getInputStream(zipEntry);
		}
		catch (IOException e) {
			return null;
		}
	}

	public Set<String> getImageFilenames() {
		Set<String> images = new TreeSet<String>();
		Enumeration<? extends ZipEntry> entries = zip.entries();
		while(entries.hasMoreElements()){
			ZipEntry e = entries.nextElement();
			String name = e.getName();
			if(name.startsWith(path+"/Img/"+id) && !name.endsWith("S.png")){
				int split = name.lastIndexOf("/");
				if(split!=-1)
					images.add(name.substring(split+1));
			}
		}
		return images;
	}
	
}
