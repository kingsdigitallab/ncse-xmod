package uk.ac.kcl.cch.ncse.prxml;

import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.URL;
import java.util.Iterator;
import java.util.List;
import java.util.zip.ZipException;
import java.util.zip.ZipFile;

import junit.framework.TestCase;

import org.xml.sax.SAXException;

import uk.ac.kcl.cch.ncse.report.TokenExtractor;

public class TocTest extends TestCase {


	public void testCreate() throws TocParsingException, ZipException, IOException, SAXException{

		URL zipUrl = TocTest.class.getResource("1851_01_04.zip");
		File zipFile = new File(zipUrl.getFile());
		ZipFile issueData = new ZipFile(zipFile);
		
		InputStream tocStream = TocTest.class.getResourceAsStream("TOC.xml");
		Toc toc = TocFactory.create(tocStream, issueData);
		
		assertNotNull(toc);
		assertEquals("Wrong number of entity ids.", 192, toc.getIds().size());
		
		// make sure all article xml files can be read (in principle) from the zip
		for(String id : toc.getIds()){
			Entity entity = toc.get(id);
			InputStream is = entity.getInputStream();
			assertNotNull(is);
			is.read();
			is.close();
		}
		
	}
	

	public void testEntitySequence(){
		final ZipFile FAKE_DATA = null;
		final String NO_PREV = null;
		final String NO_NEXT = null;
		
		Toc toc = new Toc();
		toc.add(new Entity("Article", 1, "some article", "id01", "href", "size", NO_PREV, NO_NEXT, FAKE_DATA));
		toc.add(new Entity("Article", 1, "some article", "id02", "href", "size", NO_PREV, "id03",  FAKE_DATA));
		toc.add(new Entity("Article", 1, "some article", "id03", "href", "size", "id02",  NO_NEXT, FAKE_DATA));
		toc.add(new Entity("Article", 2, "some article", "id04", "href", "size", NO_PREV, "id05",  FAKE_DATA));
		toc.add(new Entity("Article", 2, "some article", "id05", "href", "size", "id04",  "id06",  FAKE_DATA));
		toc.add(new Entity("Article", 2, "some article", "id06", "href", "size", "id05",  NO_NEXT, FAKE_DATA));
		toc.add(new Entity("Article", 3, "some article", "id07", "href", "size", "id08",  NO_NEXT, FAKE_DATA));
		toc.add(new Entity("Article", 3, "some article", "id08", "href", "size", "id09",  "id07",  FAKE_DATA));
		toc.add(new Entity("Article", 3, "some article", "id09", "href", "size", NO_PREV, "id08",  FAKE_DATA));
		
		// id01 has no links
		EntitySequence es1 = toc.getEntitySequence("id01");
		checkEntitySequence(es1, "id01");
	
		// id02 continuesTo id03
		EntitySequence es2 = toc.getEntitySequence("id02");
		checkEntitySequence(es2, "id02", "id03");
		
		// id03 continuesFrom id02
		EntitySequence es3 = toc.getEntitySequence("id03");
		checkEntitySequence(es3, "id02", "id03");
		
		// id04 -> id04-id05-id06
		EntitySequence es4 = toc.getEntitySequence("id04");
		checkEntitySequence(es4, "id04", "id05", "id06");
		
		// id05 -> id04-id05-id06
		EntitySequence es5 = toc.getEntitySequence("id05");
		checkEntitySequence(es5, "id04", "id05", "id06");
		
		// id06 -> id04-id05-id06
		EntitySequence es6 = toc.getEntitySequence("id06");
		checkEntitySequence(es6, "id04", "id05", "id06");

		// id07 -> id09-id08-id07
		EntitySequence es7 = toc.getEntitySequence("id07");
		checkEntitySequence(es7, "id09", "id08", "id07");
		
		// id08 -> id09-id08-id07
		EntitySequence es8 = toc.getEntitySequence("id08");
		checkEntitySequence(es8, "id09", "id08", "id07");
		
		// id09 -> id09-id08-id07
		EntitySequence es9 = toc.getEntitySequence("id09");
		checkEntitySequence(es9, "id09", "id08", "id07");
		
		
		// there are four distinct article sequences
		List<EntitySequence> wholeArticles = toc.getEntitySequences();
		assertEquals("Wrong number of 'whole' articles", 4, wholeArticles.size());
		Iterator<EntitySequence> i = wholeArticles.iterator();
		EntitySequence e = i.next();
		assertEquals("id01", e.toString());
		
		e = i.next();
		assertEquals("id02 id03", e.toString());

		e = i.next();
		assertEquals("id04 id05 id06", e.toString());
		
		e = i.next();
		assertEquals("id09 id08 id07", e.toString());
	}
	
	
	public void testEntitySequenceFromRealZip() throws TocParsingException, ZipException, IOException, SAXException{

		URL zipUrl = TocTest.class.getResource("1851_01_04.zip");
		File zipFile = new File(zipUrl.getFile());
		ZipFile issueData = new ZipFile(zipFile);
		
		InputStream tocStream = TocTest.class.getResourceAsStream("TOC.xml");
		Toc toc = TocFactory.create(tocStream, issueData);
	
		int numEntities = toc.getIds().size();
		List<EntitySequence> articles = toc.getEntitySequences();
		assertTrue("Some articles span multiple entities and therefore there must be more entities than articles.", numEntities > articles.size());
		assertEquals("Wrong number of re-assembled 'whole' articles.", 175, articles.size());
		
		EntitySequence article = toc.getEntitySequence("Ar00301");
		assertEquals("Wrong number of constituent entities.", 2, article.getIds().size());
		
		final StringBuilder b = new StringBuilder();
		TokenExtractor.Handler handler = new TokenExtractor.Handler(){
			public void handle(String token, String box) {
				b.append(token).append(" ");
			}
		};
		
		for(Entity e : article){
			TokenExtractor te = new TokenExtractor(handler);
			InputStream is = e.getInputStream();
			te.parse(is);
			is.close();
		}
		
		InputStream blood = TocTest.class.getResourceAsStream("blood301.txt");
		BufferedReader in = new BufferedReader(new InputStreamReader(blood, "UTF-8"));
		String concatenatedArticle = in.readLine();
		in.close();
		
		assertEquals("Concatenated article does not match reference concatenation.", concatenatedArticle, b.toString());
	}
	
	
	private void checkEntitySequence(EntitySequence actual, String... expectedIDs){
		int index = 0;
		for(Entity e : actual){
			if(index >= expectedIDs.length)
				fail("Sequence contains too many entities.");
			assertEquals("Wrong entity id.", expectedIDs[index], e.getId());
			index++;
		}
		assertEquals("Sequence contains too few entities.", expectedIDs.length, index);
	}
	
}
