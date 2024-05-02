package uk.ac.kcl.cch.ncse.util;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.UnsupportedEncodingException;
import java.util.HashSet;
import java.util.Set;
import java.util.logging.Level;
import java.util.logging.Logger;

public class WordList {

	private static final Logger LOG = Logger.getLogger(WordList.class.getCanonicalName());
	
	private static Set<String> wordList;
	private static Set<String> waterlooList;
	private static Set<String> stopWords;

	public static Set<String> getKnownWords(){
		if(wordList == null)
			wordList = get("wordlist.txt");
		return wordList;
	}

	public static Set<String> getWaterlooWords(){
		if(waterlooList == null)
			waterlooList = get("wltokens.txt");
		return waterlooList;
	}

	public static Set<String> getStopWords(){
		if(stopWords == null)
			stopWords = get("stopwords.txt");
		return stopWords;
	}
	
	private static Set<String> get(String resource){
		Set<String> words = new HashSet<String>();
		
		try {
			LOG.info("Reading word list.");
			InputStream is = WordList.class.getResourceAsStream(resource);
			BufferedReader in = new BufferedReader(new InputStreamReader(is, "UTF-8"));
			int l = 0;
			String line = null;
			while( (line=in.readLine()) !=null){
				words.add(line.trim().toLowerCase());
				l++;
				if(l % 10000 == 0)
					LOG.info(l+" lines (words) read.");
			}
			LOG.info(l+" lines (words) read.");
			in.close();
		} 
		catch (UnsupportedEncodingException e) {
			LOG.log(Level.WARNING, "While loading word list:" +e);
		} 
		catch (IOException e) {
			LOG.log(Level.WARNING, "While loading word list:" +e);
		}
		
		return words;
	}
	
}
