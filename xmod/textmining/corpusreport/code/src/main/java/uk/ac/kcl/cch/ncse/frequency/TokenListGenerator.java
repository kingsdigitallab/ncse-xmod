package uk.ac.kcl.cch.ncse.frequency;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.util.Enumeration;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.zip.ZipEntry;
import java.util.zip.ZipException;
import java.util.zip.ZipFile;

import org.xml.sax.SAXException;

import uk.ac.kcl.cch.ncse.report.Article;
import uk.ac.kcl.cch.ncse.report.QualityReportGenerator;
import uk.ac.kcl.cch.ncse.report.TokenExtractor;
import uk.ac.kcl.cch.ncse.report.TokenExtractor.Handler;
import uk.ac.kcl.cch.ncse.util.TypeCounter;

/**
 * Traverses Olive NCSE repository. Writes all tokens to a file of the form:
 * <pre>
   type,frequency
 * </pre>
 * 
 * At this stage, the types are neither sorted nor unique. Use unix sort,
 * GenerateFrequencyList and unix sort again to create the actual, final frequency list.
 * 
 * FrequencyListGenerator carries out the whole process.
 *   
 * @author patrick
 */
public class TokenListGenerator implements Handler{

	private static final int MAX_TYPES = 10000;

	private static Logger LOG = Logger.getLogger(TokenListGenerator.class.getCanonicalName());

	private File repositoryRoot;
	private File tokenSink;
	private TypeCounter types;
	private BufferedWriter out;
	
	public TokenListGenerator(File repositoryRoot, File tokenSink){
		this.repositoryRoot = repositoryRoot.getAbsoluteFile(); 
		this.tokenSink = tokenSink.getAbsoluteFile();
		this.types = new TypeCounter();
	}
	
	public void processRepository() throws IOException{
		out = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(tokenSink),"ISO-8859-1"));
		traverse(repositoryRoot);
		flush();
		out.close();
	}
	
	private void traverse(File root){
		for(File child : root.listFiles()){
			if(child.isDirectory())
				traverse(child);
			else
				try {
					handle(child);
				}
				catch (SAXException e) {
					LOG.log(Level.WARNING, "While processing: "+child, e);
				}
				catch (IOException e) {
					LOG.log(Level.WARNING, "While processing: "+child, e);
				}
		}
	}
	
	
	private void handle(File z) throws SAXException, IOException {
		if(z.getName().endsWith(".zip")){

			ZipFile zip = null;
			try {
				zip = new ZipFile(z);
			} 
			catch (ZipException ze) {
				LOG.log(Level.WARNING, "Could not process: "+z, ze);
			} 
			catch (IOException ze) {
				LOG.log(Level.WARNING, "Could not process: "+z, ze);
			}


			LOG.info("Processing: "+z);
			Enumeration<? extends ZipEntry> e = zip.entries();
			while(e.hasMoreElements()){
				ZipEntry entry = e.nextElement(); 
				if(QualityReportGenerator.isArticle(entry)){
					Article article = new Article("", 0, 0, 0, 0, "", z, entry.getName());
					TokenExtractor te = new TokenExtractor(this);
					te.parse(article.getInputStream());
				}
			}
		}
	}

	public void handle(String token, String box) {
		token = token.toLowerCase();
		if(!isRelevant(token))
			return;
		types.count(token);
		if(types.keySet().size() > MAX_TYPES)
			flush();
	}
	
	public boolean isRelevant(String token) {
		return true;
	}

	private void flush(){
		try{
			for(String type : types.keySet()){
				out.write(type+","+types.getCount(type));
				out.newLine();
			}
		}
		catch(IOException e){
			LOG.log(Level.SEVERE, "While writing partial token frequency table:", e);
		}
		types = new TypeCounter();
	}
	
}
