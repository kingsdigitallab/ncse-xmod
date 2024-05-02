package uk.ac.kcl.cch.ncse.prxml;

import java.io.IOException;
import java.io.InputStream;
import java.util.zip.ZipEntry;
import java.util.zip.ZipFile;

import org.xml.sax.Attributes;

public class Entity {

	
	private String type;
	private int page;
	private String name;
	private String id;
	private String href;
	private String size;
	private String continuationFrom;
	private String continuationTo;
	private ZipFile issueData;
	
	public Entity(String type, int page, String name, String id, String href, String size, String continuationFrom, String continuationTo, ZipFile data) {
		this.type = type;
		this.page = page;
		this.name = name;
		this.id = id;
		this.href = href;
		this.size = size;
		this.continuationFrom = continuationFrom;
		this.continuationTo = continuationTo;
		this.issueData = data;
	}

	@Override
	public String toString(){
		return 	"Entity type="+type+" page="+page+" name="+name+" id="+id+
				" href="+href+" size="+size+
				" cont'From="+continuationFrom+" cont'To="+continuationTo;
	}
	
	public String getId() {
		return id;
	}

	public String getContinuationFrom() {
		return continuationFrom;
	}
	
	public String getContinuationTo() {
		return continuationTo;
	}
	
	public String getHref(){
		return href;
	}
	
	public int getPage() {
		return page;
	}

	

	
	// currently, only Article-Entities are handled; this can be extended later by subclassing if necessary
	public InputStream getInputStream() throws IOException{
		String entryName = getHref().substring(1)+".xml";
		ZipEntry zipEntry = issueData.getEntry(entryName);
		return issueData.getInputStream(zipEntry);
	}
	
	public ImageExtractor getImageExtractor() throws IOException{
		InputStream article = getInputStream();
		ImageExtractor ie = new ImageExtractor(article, issueData, String.valueOf(getPage()));
		return ie;
	}
	
	
	
	
	
	
	
	
	

	public static Entity from(Attributes attributes, ZipFile issueData){
		
		String entityType = getValue("ENTITY_TYPE", attributes);
		Integer page = getIntegerValue("PAGE_NO", attributes);
		String name = getValue("NAME", attributes);
		String id = getValue("ID", attributes);
		String href = getValue("HREF", attributes);
		String size = getValue("SIZE", attributes);
		String continuationFrom = getValue("CONTINUATION_FROM", attributes);
		String continuationTo = getValue("CONTINUATION_TO", attributes);
		
		if(page == null)
			throw new IllegalArgumentException("Could not extract page; expected integer value.");
		
		return new Entity(entityType, page.intValue(), name, id, href, size, continuationFrom, continuationTo, issueData);
	}
	
	
	private static Integer getIntegerValue(String attributeName, Attributes attributes){
		String value = getValue(attributeName, attributes);
		try{
			return Integer.parseInt(value);
		}
		catch(NumberFormatException e){
			return null;
		}
	}
	
	private static String getValue(String attributeName, Attributes attributes){
		int i = attributes.getIndex(attributeName);
		if(i==-1)
			return null;
		return attributes.getValue(i);
	}

	public boolean isTextual() {
		return !type.equalsIgnoreCase("Picture");
	}



	
	
	
}
