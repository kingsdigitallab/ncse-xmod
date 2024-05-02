package uk.ac.kcl.cch.ncse.report;

import gate.Document;
import gate.util.GateException;

import java.net.MalformedURLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Set;
import java.util.SortedSet;
import java.util.TreeSet;

import uk.ac.kcl.cch.ncse.annie.DocUtil;
import uk.ac.kcl.cch.ncse.annie.StandAloneAnnie;
import uk.ac.kcl.cch.ncse.util.Strings;
import uk.ac.kcl.cch.ncse.util.TypeCounter;
import uk.ac.kcl.cch.ncse.util.WordList;

public class ArticleAnalyser implements TokenExtractor.Handler{
	
	private Set<String> dictionary = WordList.getKnownWords();
	private Set<String> waterlooIndex = WordList.getWaterlooWords();
	
	private Set<String> stopwords = WordList.getStopWords();
	private int allTokens;
	private int relevantWordTokens;	// only count 'relevant words', leave stopwords, punctuation, numbers, single letter tokens out
	private int knownFromDictionary;
	private int knownFromWaterloo;
	private StringBuffer text = new StringBuffer();
	private StringBuffer rawText = new StringBuffer();
	private TypeCounter types = new TypeCounter();

	private SortedSet<Integer> entityBoundaries = new TreeSet<Integer>();
	private List<Box> boxInfo = new ArrayList<Box>();
	
	
	public void markEntityBoundary() {
		entityBoundaries.add(rawText.length());
	}
	
	public void handle(String token, String box) {
		
		int start = rawText.length();
		rawText.append(token).append(" ");
		int stop = rawText.length();
		if(box!=null && box.length()>0){
			boxInfo.add(new Box(start, stop, box));
		}
		
		allTokens++;
		types.count(token);
		
		
		if(Strings.isSingleChar(token)
			||	Strings.isNumber(token)
			||	Strings.isPunctuation(token)
			||	"ENTITYBOUNDARY".equals(token)
			||	stopwords.contains(token.toLowerCase())){
		}
		else if(dictionary.contains(token.toLowerCase())){
			relevantWordTokens++;
			knownFromDictionary++;
		}
		else if(waterlooIndex.contains(token.toLowerCase())){
			relevantWordTokens++;
			knownFromDictionary++;
			knownFromWaterloo++;
		}
		else{
			relevantWordTokens++;
		}
		
		text.append(token).append(" ");
		if(allTokens % 12 == 0)
			text.append("\n");
		
	}
	
	public boolean isUnknown(String token){
		token = token.toLowerCase();
		boolean known = (		Strings.isSingleChar(token)
				||	Strings.isNumber(token)
				||	Strings.isPunctuation(token)
				||	stopwords.contains(token.toLowerCase()))
				||	dictionary.contains(token.toLowerCase())
				||  waterlooIndex.contains(token.toLowerCase());
		return !known;
	}

	public Report getReport() {
		Report r = new Report();
		r.setNumWordTokens(relevantWordTokens);
		r.setKnownTokens(knownFromDictionary);
		r.setTokensKnownFromWaterloo(knownFromWaterloo);
		
		StringBuilder html = new StringBuilder();
		try {
			Document doc = StandAloneAnnie.getAnnie().process(rawText.toString());
			DocUtil.addBoxInfo(doc, boxInfo);
			html.append(DocUtil.convertToHtml(doc, this, entityBoundaries));
			
			r.setPersons(		DocUtil.getEntities(doc, DocUtil.PERSON));
			r.setTitles(		DocUtil.getEntities(doc, DocUtil.TITLE));
			r.setOrganisations(	DocUtil.getEntities(doc, DocUtil.ORGANISATION));
			r.setLocations(		DocUtil.getEntities(doc, DocUtil.LOCATION));
			
			doc.cleanup();
		} 
		catch (GateException e) {
			e.printStackTrace();
			html.append(text.toString());
		}
		catch (MalformedURLException e) {
			e.printStackTrace();
			html.append(text.toString());
		}
		
		r.setText(html.toString());
		r.setRawText(rawText.toString());
		r.setTypeFrequencyList(types);
		r.setNumTokens(allTokens);
		r.setTotalArticles(1);
		if(allTokens>=Report.MINIMUM_LENGTH && r.getQuality()>=Report.QUALITY_THRESHOLD){
			r.setAcceptableArticles(1);
			r.setWordsFromAcceptableArticles(relevantWordTokens);
		}
		return r;
	}
	
}
