package uk.ac.kcl.cch.ncse.util;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.IOException;
import java.io.OutputStreamWriter;

public class TransformOALD {

	public static void main(String[] args) throws IOException{
		int l = 0;
		int n = 0;
		BufferedReader in = new BufferedReader(new FileReader(new File(args[0])));
		BufferedWriter out = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(args[1]), "UTF-8"));
		
		String line = null;
		while( (line=in.readLine())!=null){
			l++;
			int q1 = line.indexOf('"');
			int q2 = line.indexOf('"', q1+1);
			if(q1!=-1 && q1 < q2){
				String word = line.substring(q1+1, q2).trim();
				if(acceptable(word)){
					n++;
					out.write(word);
					out.newLine();
				}
			}
		}
		in.close();
		out.close();
		
		System.err.println(l+" lines; "+n+" word forms.");
	}
	
	private static boolean acceptable(String word){
		if(word.indexOf(" ")!=-1)		// skip multi-word units
			return false;
		
		for(int i=0; i<word.length(); i++){
			if( !Character.isLetter(word.charAt(i)))
				return false;
		}
		
		return true;
	}
	
	
}
