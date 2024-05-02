package uk.ac.kcl.cch.ncse.prxml;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.net.URL;
import java.util.Set;
import java.util.zip.ZipException;
import java.util.zip.ZipFile;

import junit.framework.TestCase;

public class ImageExtractorTest extends TestCase {
	
	private ZipFile issueData;
	private Toc toc;
	
	@Override
	protected void setUp() throws Exception {
		super.setUp();
		URL zipUrl = TocTest.class.getResource("1851_01_04.zip");
		File zipFile = new File(zipUrl.getFile());
		issueData = new ZipFile(zipFile);
		InputStream tocStream = TocTest.class.getResourceAsStream("TOC.xml");
		toc = TocFactory.create(tocStream, issueData);
	}
	
	public void testExtractSnippetImage() throws ZipException, IOException, TocParsingException{
		String id = toc.getIds().iterator().next();
		Entity e = toc.get(id);
		InputStream article = e.getInputStream();
		ImageExtractor ie = new ImageExtractor(article, issueData, "1");
		String filename = ie.getSnippetFileName();
		assertEquals("Wrong file name.", "Ar00100S.png", filename);
		InputStream is = ie.getSnippetInputStream();
		assertNotNull("Input stream must not be null.", is);
	}
	
	
	public void testExtractImages() throws IOException{
		String id = toc.getIds().iterator().next();
		Entity e = toc.get(id);
		InputStream article = e.getInputStream();
		ImageExtractor ie = new ImageExtractor(article, issueData, "1");
		
		Set<String> images = ie.getImageFilenames();
		assertEquals(3, images.size());
		assertTrue(images.contains("Ar0010000.png"));
		assertTrue(images.contains("Ar0010001.png"));
		assertTrue(images.contains("Ar0010002.png"));
		
		for(String img : images){
			InputStream is = ie.getImageInputStream(img);
			assertNotNull(is);
			is.close();
		}
	}
	
}
