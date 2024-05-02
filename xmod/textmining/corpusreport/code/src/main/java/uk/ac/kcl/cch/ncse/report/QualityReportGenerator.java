package uk.ac.kcl.cch.ncse.report;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileOutputStream;
import java.io.FileWriter;
import java.io.FilenameFilter;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.text.DecimalFormat;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.zip.ZipEntry;
import java.util.zip.ZipException;
import java.util.zip.ZipFile;

import uk.ac.kcl.cch.ncse.prxml.EntitySequence;
import uk.ac.kcl.cch.ncse.prxml.Toc;
import uk.ac.kcl.cch.ncse.prxml.TocFactory;
import uk.ac.kcl.cch.ncse.prxml.TocParsingException;
import uk.ac.kcl.cch.ncse.util.FileUtil;
import uk.ac.kcl.cch.ncse.util.Foo;

/**
 * Traverses Olive NCSE repository and generates a quality report.
 *   
 * @author patrick
 */
public class QualityReportGenerator {

	private static Logger LOG = Logger.getLogger(QualityReportGenerator.class.getCanonicalName());
	private static DecimalFormat fmt2 = new DecimalFormat("00");

	private File repositoryRoot;
	private File reportRoot;
	
	private Foo people;
	private Foo locations;
	private Foo organisations;
	
	
	public QualityReportGenerator(File repositoryRoot, File reportRoot){
		this.repositoryRoot = repositoryRoot.getAbsoluteFile(); 
		this.reportRoot = reportRoot.getAbsoluteFile();
		
		this.people = new Foo(reportRoot, "people");
		this.locations = new Foo(reportRoot, "locations");
		this.organisations = new Foo(reportRoot, "organisations");
	}
	
	public void processRepository(){
		Report corpusReport = new Report();
		corpusReport.setDescription("Corpus Repository");
		corpusReport.setLocation(new File(reportRoot, "summary.html"));
		corpusReport.setRoot(true);
		
		for(File publicationDir : repositoryRoot.listFiles())
			if(publicationDir.isDirectory()){
				Report publicationReport = processPublication(publicationDir);
				corpusReport.merge(publicationReport);
			}
		
		write(corpusReport);
		createHtmlIndices();
	}

	private void createHtmlIndices() {
		LOG.info("Writing entity index html files.");
		
		people.close();
		locations.close();
		organisations.close();
		
		try {
			IndexMaker peopleIndex = new IndexMaker(reportRoot, "people.html");
			peopleIndex.makeIndex(people.getFile());
			
			IndexMaker locationIndex = new IndexMaker(reportRoot, "locations.html");
			locationIndex.makeIndex(locations.getFile());
			
			IndexMaker organisationIndex = new IndexMaker(reportRoot, "organisations.html");
			organisationIndex.makeIndex(organisations.getFile());
		}
		catch (IOException e) {
			LOG.log(Level.SEVERE, "While writing index html file:", e);
		} 
		catch (InterruptedException e) {
			LOG.log(Level.SEVERE, "While writing index html file:", e);
		}
	}
	
	private Report processPublication(File publicationDir) {
		Report publicationReport = new Report();
		String publication = publicationDir.getName();
		publicationReport.setLocation(new File(reportRoot, publication+"/summary.html"));
		publicationReport.setDescription(publication);
		
		for(File yearDir : publicationDir.listFiles())
			if(yearDir.isDirectory()){
				Report yearReport = processYear(publication, yearDir);
				publicationReport.merge(yearReport);
			}
		
		write(publicationReport);
		return publicationReport;
	}

	private Report processYear(String publication, File yearDir) {
		LOG.info(publication);
		Report yearReport = new Report();
		
		Integer year = getNameAsInt(yearDir);
		if(year==null)
			return yearReport;
		
		yearReport.setLocation(new File(reportRoot, publication+"/"+year+"/summary.html"));
		yearReport.setDescription(publication+" "+year);

		for(File monthDir : yearDir.listFiles())
			if(monthDir.isDirectory()){
				Report monthReport = processMonth(publication, year, monthDir);
				yearReport.merge(monthReport);
			}
		
		write(yearReport);
		return yearReport;
	}

	private Report processMonth(String publication, int year, File monthDir) {
		LOG.info(publication+" "+year);
		Report monthReport = new Report();
		
		Integer month = getNameAsInt(monthDir);
		if(month==null)
			return monthReport;

		monthReport.setLocation(new File(reportRoot, publication+"/"+year+"/"+fmt2.format(month)+"/summary.html"));
		monthReport.setDescription(publication+" "+year+"/"+fmt2.format(month));
		
		for(File dayDir : monthDir.listFiles())
			if(dayDir.isDirectory()){
				Report dayReport = processDay(publication, year, month, dayDir);
				monthReport.merge(dayReport);
			}

		write(monthReport);
		return monthReport;
	}

	private Report processDay(String publication, int year, int month, File dayDir) {
		LOG.info(publication+" "+year+" "+month);
		Report dayReport = new Report();
		
		Integer day = getNameAsInt(dayDir);
		if(day==null)
			return dayReport;

		// BY:
		// We don't check for a file name made up of year, month and day
		//    any more, as sometimes ZIP files are called "Document.zip"
		// We now only check if the file name ends in ".zip"
		// final String expectedName = year+"_"+fmt2.format(month)+"_"+fmt2.format(day)+".zip";
		File[] zips = dayDir.listFiles(new FilenameFilter(){
			public boolean accept(File dir, String name) {
				// BY:
				// return name.equalsIgnoreCase(expectedName);
				return name.endsWith(".zip");
			}} 
		);
		if(zips.length==1){
			dayReport = processZipAndToc(publication, year, month, day, zips[0]);
		}
		else{
			LOG.log(Level.SEVERE, "Expected exactly one archive: "+publication+" "+year+"/"+fmt2.format(month)+"/"+fmt2.format(day));
		}

		dayReport.setLocation(new File(reportRoot, publication+"/"+year+"/"+fmt2.format(month)+"/"+fmt2.format(day)+"/summary.html"));
		dayReport.setDescription(publication+" "+year+"/"+fmt2.format(month)+"/"+fmt2.format(day));
		write(dayReport);
		return dayReport;
	}

	private Report processZipAndToc(String publication, int year, int month, Integer day, File z) {
		Report zipReport = new Report();
		
		// BY:
		// We don't check for a file name made up of year, month and day
		//    any more, as sometimes ZIP files are called "Document.zip"
		// We now only check if the file name ends in ".zip"
		// String expectedName = year+"_"+fmt2.format(month)+"_"+fmt2.format(day)+".zip";
		String currzipfileName = z.getName();
		LOG.info("Processing "+publication+" "+currzipfileName);
		// if(expectedName.equals(z.getName())){
		if(z.getName().endsWith(".zip")){

			// LOG.log(Level.WARNING, "Could not process: "+z, ze);

			ZipFile zip = null;
			try {
				zip = new ZipFile(z);
			} 
			catch (ZipException ze) {
				LOG.log(Level.WARNING, "Could not process: "+z, ze);
				return zipReport;
			} 
			catch (IOException ze) {
				LOG.log(Level.WARNING, "Could not process: "+z, ze);
				return zipReport;
			}
			
			File dir = z.getParentFile();
			File tocFile = new File(dir, "TOC.xml");
			if(!tocFile.canRead()){
				LOG.log(Level.WARNING, "Could not read TOC.xml file: "+tocFile);
				return zipReport;
			}
			
			try {
				Toc toc = TocFactory.create(tocFile, zip);
				for(EntitySequence completeArticle : toc.getEntitySequences()){
					String relativeURL = publication+"/"+year+"/"+fmt2.format(month)+"/"+fmt2.format(day)+"/"+completeArticle.getFirstPage()+"/"+completeArticle.getShortId()+".html"; 
					File rf = new File(reportRoot, relativeURL);
					String reportURL = publication+"/"+year+"/"+fmt2.format(month)+"/"+fmt2.format(day)+"/"+completeArticle.getFirstPage(); 
					File reportdir = new File(reportRoot, reportURL);
					Report articleReport = Report.create(completeArticle, reportdir);
					articleReport.setLocation(rf);
					articleReport.setDescription(publication+" "+year+"/"+fmt2.format(month)+"/"+fmt2.format(day)+" page "+completeArticle.getFirstPage()+" "+completeArticle.getCompoundId());
					write(articleReport);
					zipReport.merge(articleReport);
					writeArticleAsPlainText(publication, year, month, day, completeArticle, articleReport);
				}
			} 
			catch (TocParsingException e) {
				LOG.log(Level.WARNING, "While reading TOC.xml: "+tocFile, e);
				return zipReport;
			}

		}
		else
			LOG.log(Level.WARNING, "Did not process: "+z+" expected: "+currzipfileName+" instead!");
		
		return zipReport;
	}

	private void writeArticleAsPlainText(String publication, int year, int month, Integer day, EntitySequence completeArticle, Report articleReport) {
		String plainName = publication+"_"+year+"_"+fmt2.format(month)+"_"+fmt2.format(day)+"_"+completeArticle.getFirstPage()+"_"+completeArticle.getShortId()+".txt"; 
		String plainURL = publication+"/"+year+"/"+fmt2.format(month)+"/"+fmt2.format(day)+"/"+completeArticle.getFirstPage()+"/"+plainName; 
		File plainFile = new File(reportRoot, plainURL);
		writePlainText(articleReport, plainFile);
	}

	
	private void writePlainText(Report report, File destination) {
		String txt = report.getRawText();
		if(txt == null || txt.length()==0)
			return;
		try {
			BufferedWriter out = new BufferedWriter(new FileWriter(destination));
			out.write(txt);
			out.close();
		} 
		catch (IOException e) {
			LOG.log(Level.WARNING, "Exception while writing plain text version of article: ", e);
		}
	}

	private void write(Report r) {
		write(r, r.getLocation());
		
		String relativeURL = FileUtil.makeRelative(reportRoot.getAbsolutePath(), r.getLocation().getAbsolutePath());
		people.write(r.getPersons(), relativeURL);
		locations.write(r.getLocations(), relativeURL);
		organisations.write(r.getOrganisations(), relativeURL);
	}

	private void write(Report report, File rf) {
		FileUtil.createDirectoriesIfNecessary(rf);
		try {
			BufferedWriter out = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(rf), "UTF-8"));
			out.write(report.toHTML());
			out.close();
		} 
		catch (IOException e) {
			LOG.log(Level.WARNING, "While writing report.", e);
		}
	}

	private static Integer getNameAsInt(File dir){
		try{
			return Integer.parseInt(dir.getName());
		}
		catch(NumberFormatException e){
			return null;
		}
	}
	
	public static boolean isArticle(ZipEntry entry) {
		String name = entry.getName();
		String lastComponent = getLastComponent(name);
		return		lastComponent.startsWith("Ar") 
				&&	lastComponent.endsWith(".xml");
	}
	
	private static String getLastComponent(String s){
		int split = s.lastIndexOf("/");
		if(split==-1)
			return s;
		else
			return s.substring(split+1);
	}

	
	
	public static void main(String[] args){
		QualityReportGenerator t = new QualityReportGenerator(new File(args[0]), new File(args[1]));
		t.processRepository();
	}
	
}
