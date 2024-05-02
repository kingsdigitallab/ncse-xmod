package uk.ac.kcl.cch.ncse.util;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.Map.Entry;

public class TypeCounter {

	public static final String NUMBER = "___number___";
	public static final String PUNCTUATION = "___punctuation___";
	
	
	private Map<String, Integer> counts;
	int total;

	public TypeCounter(){
		counts = new HashMap<String, Integer>();
		total = 0;
	}
	
	public void count(String t){
		total++;
		t = resolve(t);
		Integer i = counts.get(t);
		if(i==null)
			i = 1;
		else
			i = i+1;
		counts.put(t, i);
	}
	
	public int getCount(String t){
		t = resolve(t);
		Integer i = counts.get(t);
		if(i==null)
			return 0;
		else
			return i;
	}
	
	public Set<String> keySet(){
		return counts.keySet();
	}
	
	public Set<Map.Entry<String, Integer>> entries(){
		return counts.entrySet();
	}
	
	private static final Comparator<Entry<String,Integer>> COMP = new Comparator<Entry<String,Integer>>(){
		public int compare(Entry<String, Integer> o1, Entry<String, Integer> o2) {
			int c = o2.getValue()-o1.getValue();
			if(c==0){
				return o1.getKey().compareTo(o2.getKey());
			}
			else
				return c;
		}
	};

	public List<Map.Entry<String, Integer>> elementsSortedAccordingToFrequency(){
		List<Map.Entry<String, Integer>> sorted = new ArrayList<Map.Entry<String, Integer>>(entries());
		Collections.sort(sorted, COMP);
		return sorted;
	}
	
	private static String resolve(String t){
		try{
			Integer.parseInt(t);
			return NUMBER;
		}
		catch(NumberFormatException e1){
			try{
				Double.parseDouble(t);
				return NUMBER;
			}
			catch(NumberFormatException e2){
				if(containsOnlyNonAlphaNumericalChars(t))
					return PUNCTUATION;
				else
					return t;
			}
		}
	}
	
	public static boolean containsOnlyNonAlphaNumericalChars(String s) {
		for(int i=0; i<s.length(); i++){
			char ch = s.charAt(i);
			if(Character.isLetterOrDigit(ch)){
				return false;
			}
		}
		return true;
	}

	public int getTotal() {
		return total;
	}
	
}
