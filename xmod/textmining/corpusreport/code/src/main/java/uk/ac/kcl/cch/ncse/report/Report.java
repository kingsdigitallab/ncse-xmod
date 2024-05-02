package uk.ac.kcl.cch.ncse.report;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.List;
import java.util.Set;
import java.util.Map.Entry;
import java.util.logging.Level;
import java.util.logging.Logger;

import org.apache.commons.lang.StringEscapeUtils;
import org.xml.sax.SAXException;

import uk.ac.kcl.cch.ncse.annie.EntityAndBoundingBox;
import uk.ac.kcl.cch.ncse.prxml.Entity;
import uk.ac.kcl.cch.ncse.prxml.EntitySequence;
import uk.ac.kcl.cch.ncse.prxml.ImageExtractor;
import uk.ac.kcl.cch.ncse.util.FileUtil;
import uk.ac.kcl.cch.ncse.util.TypeCounter;

public class Report {

	// TODO: use system property to make this overridable
	private static final String OLIVE_ENCODING = "windows-1252";
	
	private static Logger LOG = Logger.getLogger(Report.class.getCanonicalName());
	
	public static Report create(EntitySequence completeArticle, File targetdir) {
		ArticleAnalyser aa = new ArticleAnalyser();
		List<String> imageFileNames = new ArrayList<String>();
		String snippetSource = null;
		try {
			TokenExtractor te = new TokenExtractor(aa);
			for(Entity part : completeArticle){
				
				LOG.info("Processing "+part.toString());
				if (!part.isTextual()){
					LOG.info("Skipping non-article entity.");
					continue;
				}

				te.parse(new InputStreamReader(part.getInputStream(), OLIVE_ENCODING));
				aa.markEntityBoundary();

				ImageExtractor ie = part.getImageExtractor();
				String snippetFilename = ie.getSnippetFileName();
				if (snippetFilename != null) {
					File target = new File(targetdir, snippetFilename);
					FileUtil.createDirectoriesIfNecessary(target);
					copy(ie.getSnippetInputStream(), new FileOutputStream(target));
					snippetSource = target.getName();
				}
				for(String imageFilename : ie.getImageFilenames()){
					File target = new File(targetdir, imageFilename);
					FileUtil.createDirectoriesIfNecessary(target);
					copy(ie.getImageInputStream(imageFilename), new FileOutputStream(target));
					imageFileNames.add(target.getName());
				}
				
			}
		} 
		catch (SAXException e) {
			LOG.log(Level.WARNING, "While analysing article:", e);
		} 
		catch (IOException e) {
			LOG.log(Level.WARNING, "While analysing article:", e);
		}
		Report r = aa.getReport();
		r.setSnippet(snippetSource);
		r.addImages(imageFileNames);
		return r;
	}

	private static void copy(InputStream in, FileOutputStream out) throws IOException {
		if(in != null){
			byte[] buffer = new byte[2048];
			int b = 0;
			while ((b = in.read(buffer)) != -1) {
				out.write(buffer, 0, b);
			}
			in.close();
			out.close();
		}
	}

	
	
	
	public static final double QUALITY_THRESHOLD = 70;
	public static final double MINIMUM_LENGTH = 20;
	private static DecimalFormat f = new DecimalFormat("#00.00");
	private static class ChildLink{
		public final File location;
		public final double qualityScore;
		public final int length;
		public final String description;
		public ChildLink(Report r){
			location = r.location;
			qualityScore = r.getQuality();
			description = r.getDescription();
			length = r.getNumTokens();
		}
		
		public String toHtml(File parentLocation){
			String rel = FileUtil.makeRelative(parentLocation.getAbsolutePath(), location.getAbsolutePath());
			return "<font face=\"monospace\"><a href=\"."+rel+"\">"+description+"</a>"+formatQuality()+formatLength()+"</font>";
		}
		
		private String formatQuality(){
			StringBuilder b = new StringBuilder(" -- ");
			if(qualityScore < QUALITY_THRESHOLD)
				b.append("<font color=\"#FF0000\">");
			
			b.append(f.format(qualityScore)).append("%");
			
			if(qualityScore < QUALITY_THRESHOLD)
				b.append("</font>");
			
			return b.toString();
		}
		
		private String formatLength(){
			if(length<=0)
				return "";
			
			StringBuilder b = new StringBuilder("    -- ");
			if(length < MINIMUM_LENGTH)
				b.append("<font color=\"#FF0000\">");
			
			b.append(length).append(" tokens");
			
			if(length < MINIMUM_LENGTH)
				b.append("</font>");
			
			return b.toString();
		}
		
	}
	
	
	private File location;
	private String description;
	private List<ChildLink> children;
	private boolean isRoot;
	
	private int numTokens;
	private int numWordTokens;
	private int knownTokens;
	private String text;
	private String rawText;
	private int acceptableArticles;
	private int totalArticles;
	private int wordsFromAcceptableArticles;
	private TypeCounter frequencies;
	
	private Set<EntityAndBoundingBox> persons;
	private Set<EntityAndBoundingBox> titles;
	private Set<EntityAndBoundingBox> locations;
	private Set<EntityAndBoundingBox> organisations;
	
	private String snippetSrc;
	private List<String> images;

	private int knownWaterlooTokens;
	
	public Report(){
		numWordTokens = 0;
		knownTokens = 0;
		children = new ArrayList<ChildLink>();
		description = "???";
		text = "";
		acceptableArticles = 0;
		totalArticles = 0;
		wordsFromAcceptableArticles = 0;
	}
	
	public void setRoot(boolean b){
		isRoot = b;
	}
	
	
	public File getLocation() {
		return location;
	}

	public void setLocation(File location) {
		this.location = location;
	}

	
	
	public int getNumWordTokens() {
		return numWordTokens;
	}

	public void setNumWordTokens(int numTokens) {
		this.numWordTokens = numTokens;
	}

	public void addImages(List<String> imagelinks) {
		this.images = imagelinks;
	}
	
	public void setSnippet(String snippetSource){
		this.snippetSrc = snippetSource;
	}
	
	
	@Override
	public String toString() {
		return knownTokens+" / "+numWordTokens+" known; "+( 100.0 * knownTokens / numWordTokens )+"%";
	}
	
	
	public void merge(Report report) {
		numWordTokens += report.numWordTokens;
		knownTokens += report.knownTokens;
		knownWaterlooTokens += report.knownWaterlooTokens;
		children.add(new ChildLink(report));
		acceptableArticles += report.acceptableArticles;
		totalArticles += report.totalArticles;
		wordsFromAcceptableArticles += report.wordsFromAcceptableArticles;
	}

	double getQuality() {
		if(numWordTokens==0)
			return 0.0;
		return ( 100.0 * knownTokens / numWordTokens );
	}

	double getWlQuality() {
		if(numWordTokens==0)
			return 0.0;
		return ( 100.0 * knownWaterlooTokens / numWordTokens );
	}


	public String toHTML() {
		StringBuilder b = new StringBuilder();
		
		b.append("<?xml version=\"1.0\" ?>").append("\n");
		b.append("<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\"").append("\n");
		b.append("    \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\">").append("\n");
		b.append("<html xmlns=\"http://www.w3.org/1999/xhtml\">").append("\n");
		b.append("<head>").append("\n");
		b.append("<title>").append(description).append("</title>").append("\n");
		b.append("</head>").append("\n");
		b.append("<body>").append("\n");
		
		b.append("<H1>").append(description).append("</H1>\n");
		
		addParentLink(b);
		
		b.append(knownTokens+" / "+numWordTokens+" known (dictionary + Waterloo); ").append(f.format(getQuality())).append("%<br/>");
		b.append(knownWaterlooTokens+" / "+numWordTokens+" known from Waterloo; ").append(f.format(getWlQuality())).append("%<br/>");
		
		if(totalArticles>1){
			b.append("<br>").append(acceptableArticles).append(" / ").append(totalArticles).append(" articles acceptable; ");
			b.append(f.format( 100.0 * acceptableArticles/totalArticles )).append("%");
			b.append(" -- accounting for ").append(wordsFromAcceptableArticles).append(" / ").append(numWordTokens).append(" word tokens; ");
			b.append(f.format( 100.0 * wordsFromAcceptableArticles / numWordTokens)).append("%");
		}
		
		if(children.size()>0){
			b.append("<br><UL>\n");
			for(ChildLink cl : children)
				b.append("   <LI>").append(cl.toHtml(location.getParentFile())).append("</LI>\n");
			b.append("</UL>\n");
		}

		if(text.length()>0){
			
			appendEntitySummary(b);
			
			b.append(text);
			
			if(frequencies!=null){
				b.append("\n<HR>");
				b.append("\n<table>");
				for(Entry<String, Integer> e : frequencies.elementsSortedAccordingToFrequency()){
					b.append("\n<tr><td>");
					b.append(e.getKey());
					b.append("</td><td align=\"right\">");
					b.append(e.getValue());
					b.append("</td></tr>");
				}
				b.append("<tr><td>TOTAL</td><td align=\"right\">");
				b.append(frequencies.getTotal());
				b.append("</td></tr>");
				
				b.append("</table>\n");
			}
		}
		
		addParentLink(b);
		
		b.append("</body></html>");
		return b.toString();
	}

	private void appendImages(StringBuilder b) {
		if(snippetSrc != null){
			b.append("<br/><img src=\""+snippetSrc+"\" alt=\"Snippet\"><br/>\n");
		}
		
		if(images != null){
			int i = 1;
			b.append("<br/>\n");
			for(String image : images){
				b.append("<a target=\"_blank\" href=\""+image+"\">Image "+i+"</a>&nbsp;\n");
				i++;
			}
		}
	}
	
	private void appendEntitySummary(StringBuilder b) {
		b.append("<table>");
		b.append("<tr>");
		b.append("<th>Persons</th>").append("<th>Titles</th>").append("<th>Organisations</th>").append("<th>Locations</th>");
		b.append("</tr>");

		b.append("<tr>");
		b.append("<td valign=\"top\">").append(toHtml(persons)).append("</td>");
		b.append("<td valign=\"top\">").append(toHtml(titles)).append("</td>");
		b.append("<td valign=\"top\">").append(toHtml(organisations)).append("</td>");
		b.append("<td valign=\"top\">").append(toHtml(locations)).append("</td>");
		b.append("</tr>");
		
		b.append("/<table> <hr>");
	}

	private String toHtml(Set<EntityAndBoundingBox> entities){
		if(entities==null)
			return "";
		StringBuilder b = new StringBuilder();
		b.append("<ul>");
		
		for(EntityAndBoundingBox eab : entities){
			b.append("<li>");
			b.append(StringEscapeUtils.escapeHtml(eab.entity));
			b.append("</li>");
		}
		
		b.append("</ul>");
		return b.toString();
	}
	

	private void addParentLink(StringBuilder b) {
		if(isRoot)
			return;
		
		if(text==null || text.length()==0)
			b.append("<hr><a href=\"../summary.html\">up</a><hr>");
		else if(text!=null && text.length()>0){
			b.append("<hr><table><tr><td><a href=\"../summary.html\">up</a></td><td>");
			b.append("<a href=\"../../../../../people.html\">People index</a></td><td>");
			b.append("<a href=\"../../../../../locations.html\">Location index</a></td><td>");
			b.append("<a href=\"../../../../../organisations.html\">Organisation index</a></td></tr></table>");
			appendImages(b);
			b.append("<hr>");
		}
	}


	public void setKnownTokens(int known) {
		knownTokens = known;
	}


	public String getDescription() {
		return description;
	}


	public void setDescription(String description) {
		this.description = description;
	}


	public String getText() {
		return text;
	}


	public void setText(String text) {
		this.text = text;
	}

	public void setRawText(String t){
		rawText = t;
	}

	public String getRawText(){
		return rawText;
	}
	
	public int getNumTokens() {
		return numTokens;
	}


	public void setNumTokens(int numTokens) {
		this.numTokens = numTokens;
	}


	public int getAcceptableArticles() {
		return acceptableArticles;
	}


	public void setAcceptableArticles(int acceptableArticles) {
		this.acceptableArticles = acceptableArticles;
	}


	public int getTotalArticles() {
		return totalArticles;
	}


	public void setTotalArticles(int totalArticles) {
		this.totalArticles = totalArticles;
	}


	public int getWordsFromAcceptableArticles() {
		return wordsFromAcceptableArticles;
	}


	public void setWordsFromAcceptableArticles(int wordsFromAcceptableArticles) {
		this.wordsFromAcceptableArticles = wordsFromAcceptableArticles;
	}

	public void setTypeFrequencyList(TypeCounter typeFrequencies) {
		frequencies = typeFrequencies;
	}


	public void setLocations(Set<EntityAndBoundingBox> locations) {
		this.locations = locations;
	}


	public void setOrganisations(Set<EntityAndBoundingBox> organisations) {
		this.organisations = organisations;
	}


	public void setPersons(Set<EntityAndBoundingBox> persons) {
		this.persons = persons;
	}


	public void setTitles(Set<EntityAndBoundingBox> titles) {
		this.titles = titles;
	}

	public Set<EntityAndBoundingBox> getLocations() {
		return locations;
	}

	public Set<EntityAndBoundingBox> getOrganisations() {
		return organisations;
	}

	public Set<EntityAndBoundingBox> getPersons() {
		return persons;
	}

	public Set<EntityAndBoundingBox> getTitles() {
		return titles;
	}

	public void setTokensKnownFromWaterloo(int knownFromWaterloo) {
		knownWaterlooTokens = knownFromWaterloo;
	}
	
}
