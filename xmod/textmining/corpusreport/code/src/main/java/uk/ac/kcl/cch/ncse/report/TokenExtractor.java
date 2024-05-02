package uk.ac.kcl.cch.ncse.report;

import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.Reader;

import org.xml.sax.Attributes;
import org.xml.sax.InputSource;
import org.xml.sax.SAXException;
import org.xml.sax.XMLReader;
import org.xml.sax.helpers.DefaultHandler;
import org.xml.sax.helpers.XMLReaderFactory;

public class TokenExtractor extends DefaultHandler{

	public interface Handler {
		public void handle(String token, String box);
	}
	
	
	private static final int IGNORE = 0;
	private static final int WORD = 1;

	private int state = IGNORE;
	private String box = "";

	private XMLReader parser;

	private Handler handler;

	public TokenExtractor(Handler consumer) throws SAXException{
		parser = XMLReaderFactory.createXMLReader();
		parser.setContentHandler(this);
		parser.setErrorHandler(this);
		handler = consumer;
	}

	public void parse(InputStream is) throws IOException, SAXException{
		parse(new InputStreamReader(is));
	}
	
	public void parse(Reader r) throws IOException, SAXException{
		parser.parse(new InputSource(r));
	}


	@Override
	public void startElement(String uri, String localName, String qName, Attributes attributes) throws SAXException {
		if(		"W".equals(localName)
			|| 	"QW".equals(localName)){
			state = WORD;
			box = "BOX=\""+String.valueOf(attributes.getValue("BOX"))+"\"";
		}
		else{
			state = IGNORE;
			box = "";
		}
	}

	public void characters (char ch[], int start, int length){
		if(state == IGNORE)
			return;

		StringBuilder b = new StringBuilder();
		for (int i = start; i < start + length; i++)
			b.append(ch[i]);

		String token = b.toString().trim();
		handler.handle(token, box);
	}

	@Override
	public void endElement(String uri, String localName, String qName) throws SAXException {
		state = IGNORE;
	}

}
