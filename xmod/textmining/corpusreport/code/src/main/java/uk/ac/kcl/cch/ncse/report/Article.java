package uk.ac.kcl.cch.ncse.report;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.util.zip.ZipEntry;
import java.util.zip.ZipFile;

/**
 * An article in the Olive NCSE repository.
 * 
 * @author patrick
 */
public class Article {

	private String publication;
	private int year;
	private int month;
	private int day;
	
	private String articleId;
	private int page;
	
	private File zipFile;
	private String zipEntryName;
	
	
	public Article(String pub, int yyyy, int mm, int dd, int p, String artName, File zip, String entryName){
		publication = pub;
		year = yyyy;
		month = mm;
		day = dd;
		page = p;
		articleId = artName;
		zipFile = zip;
		zipEntryName = entryName;
	}
	
	@Override
	public String toString() {
		return	publication+" "+articleId+
				" year:"+year+" month:"+month+" day:"+day+" page:"+page+
				" "+zipFile.getAbsolutePath()+" ; "+zipEntryName;
	}
	
	public InputStream getInputStream() throws IOException{
		ZipFile z = new ZipFile(zipFile);
		ZipEntry e = z.getEntry(zipEntryName);
		return z.getInputStream(e);
	}
	
}