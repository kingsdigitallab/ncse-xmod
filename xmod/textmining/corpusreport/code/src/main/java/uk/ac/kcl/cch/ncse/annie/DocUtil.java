package uk.ac.kcl.cch.ncse.annie;

import gate.Annotation;
import gate.AnnotationSet;
import gate.Document;
import gate.DocumentContent;
import gate.Factory;
import gate.FeatureMap;
import gate.util.InvalidOffsetException;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Set;
import java.util.SortedSet;
import java.util.TreeSet;
import java.util.logging.Level;
import java.util.logging.Logger;

import org.apache.commons.lang.StringEscapeUtils;

import uk.ac.kcl.cch.ncse.report.ArticleAnalyser;
import uk.ac.kcl.cch.ncse.report.Box;

public class DocUtil {

	private static final Logger LOG = Logger.getLogger(DocUtil.class.getName());
	
	public static final String PERSON = "Person";
	public static final String LOCATION = "Location";
	public static final String ORGANISATION = "Organization";
	public static final String TITLE = "Title";
	
	public static void addBoxInfo(Document doc, List<Box> boxInfo) {
		for(Box b : boxInfo){
			FeatureMap fm = Factory.newFeatureMap();
			fm.put("box", b.box);
			try {
				doc.getAnnotations().add(b.start, b.end, "box", fm);
			} 
			catch (InvalidOffsetException e) {
				LOG.log(Level.WARNING, "While adding bounding box information to document:", e);
			}
		}
	}

	
	public static Set<EntityAndBoundingBox> getEntities(Document doc, String...types){
		SortedSet<EntityAndBoundingBox> entities = new TreeSet<EntityAndBoundingBox>();
		
		AnnotationSet defaultAnnotSet = doc.getAnnotations();

		Set<String> aTypes = new HashSet<String>();
		for(String type : types)
			aTypes.add(type);
		
		Set<Annotation> relevantAnnotations = defaultAnnotSet.get(aTypes);
		List<Annotation> entityList = new ArrayList<Annotation>(relevantAnnotations);
		Collections.sort(entityList, new gate.util.OffsetComparator()); 

		Iterator<Annotation> p = entityList.iterator();
		while(p.hasNext()){
			Annotation pa = p.next();
			DocumentContent aPerson;
			try {
				aPerson = doc.getContent().getContent(pa.getStartNode().getOffset(), pa.getEndNode().getOffset());
				
				StringBuilder box = new StringBuilder();
				Set<Annotation> boxes = defaultAnnotSet.get("box", pa.getStartNode().getOffset(), pa.getEndNode().getOffset());
				for(Annotation x : boxes)
					box.append(x.getFeatures().get("box")).append(";");
				
				EntityAndBoundingBox eab = new EntityAndBoundingBox(aPerson.toString(), box.toString());
				entities.add(eab);
			}
			catch (InvalidOffsetException e) {
				LOG.log(Level.WARNING, e.getMessage(), e);
			}
		}
		
		return entities;
	}
	
	
	public static String convertToHtml(Document doc){
		return convertToHtml(doc, new ArticleAnalyser(){
			@Override
			public boolean isUnknown(String token) {
				return false;
			}
		});
	}
	
	public static String convertToHtml(Document doc, ArticleAnalyser analyser){
		return convertToHtml(doc, analyser, new TreeSet<Integer>());
	}
	
	public static String convertToHtml(Document doc, ArticleAnalyser analyser, SortedSet<Integer> entityBoundaries){
		
	      AnnotationSet defaultAnnotSet = doc.getAnnotations();
	      // System.err.println(defaultAnnotSet.getAllTypes());
	      
	      Set<String> annotTypesRequired = new HashSet<String>();
	      annotTypesRequired.add(PERSON);
	      annotTypesRequired.add(LOCATION);
	      annotTypesRequired.add(ORGANISATION);
	      annotTypesRequired.add(TITLE);
	      AnnotationSet relevantAnnotations = defaultAnnotSet.get(annotTypesRequired);

	      
	      
	      Set<String> t = new HashSet<String>();
	      t.add("Token");
	      Set<Annotation> tokens = defaultAnnotSet.get(t);
	      List<Annotation> tokenList = new ArrayList<Annotation>(tokens);
	      Collections.sort(tokenList, new gate.util.OffsetComparator()); 
	      
	      StringBuilder result = new StringBuilder("<p>");
	      int lengthInCharacters = 0;
	      
	      int nextBoundary = 0;
	      if(entityBoundaries.size()>0){
	    	  nextBoundary = entityBoundaries.first();
	    	  entityBoundaries.remove(nextBoundary);
	      }
	      else
	    	  nextBoundary = Integer.MAX_VALUE;
	    	  
	      int z = 0;
	      for(Iterator ti = tokenList.iterator(); ti.hasNext(); ){
	    	  Annotation x = (Annotation) ti.next();
	    	  
	    	  FeatureMap fm = x.getFeatures();

	    	  String surface = (String) fm.get("string");
	    	  lengthInCharacters += surface.length()+1;
	    	  
	    	  boolean unknownSurface = analyser.isUnknown(surface);
	    	  
	    	  
	    	  String entityTypes = getEntityTypes(relevantAnnotations, x.getStartNode().getOffset(), x.getEndNode().getOffset());
	    	  
	    	  if(!entityTypes.equals("")){
	    		  result.append("<font color=\"#0000FF\" title=\""+entityTypes+"\">");
	    	  }
	    	  else if(unknownSurface)
	    		  result.append("<font color=\"#FF0000\">");
	    		  
	    	  result.append(StringEscapeUtils.escapeHtml(surface));

	    	  if(!entityTypes.equals("") || unknownSurface)
	    		  result.append("</font>");
	    	  
	    	  result.append(" ");
	    	  
	    	  z++;
	    	  if(z%8==0)
	    		  result.append("\n");
	    	  
	    	  if(lengthInCharacters >= nextBoundary){
	    		  result.append("\n<hr>\n");
	    		  if(entityBoundaries.size()>0){
	    	    	  nextBoundary = entityBoundaries.first();
	    	    	  entityBoundaries.remove(nextBoundary);
	    	      }
	    	      else
	    	    	  nextBoundary = Integer.MAX_VALUE;
	    	  }
	    	  
	      }
	      result.append("</p>");
		
		
		return result.toString();
		
	}
	
	private static String getEntityTypes(AnnotationSet entities, long start, long stop){
		Set<Annotation> found = entities.get(start, stop);
		String types = "";
		
		for(Iterator<Annotation> i = found.iterator(); i.hasNext(); ){
			Annotation a = i.next();
			String type = a.getType();
			types += type;
			if(i.hasNext())
				types += ", ";
		}
		return types;
	}
	
	
}
