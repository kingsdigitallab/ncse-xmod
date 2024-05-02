package uk.ac.kcl.cch.ncse.prxml;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.Reader;
import java.util.zip.ZipFile;

import org.xml.sax.Attributes;
import org.xml.sax.InputSource;
import org.xml.sax.SAXException;
import org.xml.sax.XMLReader;
import org.xml.sax.helpers.DefaultHandler;
import org.xml.sax.helpers.XMLReaderFactory;

/**
 * Creates a Toc from a TOC.xml file and associates it with the zip file containing 
 * the issue data.
 * 
 * @author patrick
 */
public class TocFactory extends DefaultHandler{
	
	public static Toc create(File tocFile, ZipFile issueData) throws TocParsingException{
		try {
			return create(new FileInputStream(tocFile), issueData);
		}
		catch (FileNotFoundException e) {
			throw new TocParsingException(e);
		}
	}
	
	public static Toc create(InputStream is, ZipFile issueData) throws TocParsingException{
		try{
			TocFactory p = new TocFactory(issueData);
			p.parse(is);
			is.close();
			return p.toc;
		}
		catch(SAXException e){
			throw new TocParsingException(e);
		} 
		catch (IOException e) {
			throw new TocParsingException(e);
		}
	}
	

	private XMLReader parser;
	private Toc toc;
	private ZipFile issueData;

	private TocFactory(ZipFile data) throws SAXException{
		issueData = data;
		toc = new Toc();
		parser = XMLReaderFactory.createXMLReader();
		parser.setContentHandler(this);
		parser.setErrorHandler(this);
	}

	private void parse(InputStream is) throws IOException, SAXException{
		parse(new InputStreamReader(is));
	}
	
	private void parse(Reader r) throws IOException, SAXException{
		parser.parse(new InputSource(r));
		r.close();
	}

	@Override
	public void startElement(String uri, String localName, String qName, Attributes attributes) throws SAXException {
		if("Entity".equals(localName)){
			Entity e = Entity.from(attributes, issueData);
			toc.add(e);
		}
	}

	

}
