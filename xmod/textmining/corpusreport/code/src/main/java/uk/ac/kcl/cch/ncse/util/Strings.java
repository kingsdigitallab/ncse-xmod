package uk.ac.kcl.cch.ncse.util;

public class Strings {

	public static boolean isSingleChar(String s){
		return s.length()==1 && Character.isLetterOrDigit(s.charAt(0));
	}
	
	public static boolean isNumber(String n){
		try{
			Integer.parseInt(n);
			return true;
		}
		catch(NumberFormatException e1){
			try{
				Double.parseDouble(n);
				return true;
			}
			catch(NumberFormatException e2){
				return false;
			}
		}
	}
	
	public static boolean isPunctuation(String p){
		for(int i=0; i<p.length(); i++)
			if(Character.isLetterOrDigit(p.charAt(i)))
				return false;
		return true;
	}
	
}
