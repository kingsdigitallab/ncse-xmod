package uk.ac.kcl.cch.ncse.report;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.util.Iterator;
import java.util.SortedSet;
import java.util.TreeSet;

import org.apache.commons.lang.StringEscapeUtils;

import uk.ac.kcl.cch.ncse.util.UnixSortUtil;

public class IndexMaker {

	private BufferedWriter out;
	
	public IndexMaker(File output) throws IOException{
		out = new BufferedWriter(new FileWriter(output));
	}
	
	public IndexMaker(File reportRoot, String filename) throws IOException {
		this(new File(reportRoot, filename));
	}

	public void makeIndex(File rawIndex) throws IOException, InterruptedException{
		File temp = File.createTempFile("index", ".tmp");
		temp.deleteOnExit();
		UnixSortUtil.sort(rawIndex, temp);
		
		BufferedReader in = new BufferedReader(new FileReader(temp));
		
		SortedSet<String> urls = new TreeSet<String>();
		String old = null;
		String line = null;
			
		while( (line=in.readLine())!=null ){
			
			line = line.trim();
			if(line.length()==0)
				continue;
			
			String entity = getEntity(line);
			String url = getURL(line);
			if(entity==null || url == null)
				continue;
			
			if(!entity.equals(old)){
				write(old, urls);
				urls.clear();
				old = entity;
			}
			urls.add(url);
			
		}
		write(old, urls);
		in.close();
		out.close();
	}
	
	private void write(String entity, SortedSet<String> urls) throws IOException {
		if(entity==null)
			return;
		
		out.write("<H3>");
		out.write(StringEscapeUtils.escapeHtml(entity));
		out.write("</H3>\n");
		
		out.write("<table cellspacing=\"2\" cellpadding=\"2\" border=\"1\">\n");
		Iterator<String> u = urls.iterator();
		while(u.hasNext()){	
			out.write("<tr>");
			for(int i=0; i<3; i++){
				out.write("<td>");
				if(u.hasNext()){
					String url = u.next();
					out.write("<a href=\"./"+url+"\">"+StringEscapeUtils.escapeHtml(url)+"</a>");
				}
				out.write("</td>");
			}
			out.write("</tr>\n");
		}
		out.write("</table>\n");
	}

	private static String getEntity(String line){
		int split = line.indexOf("\t");
		if(split==-1)
			return null;
		else
			return line.substring(0, split);
	}
	
	private static String getURL(String line){
		int split1 = line.indexOf("\t");
		int split2 = line.lastIndexOf("\t");
		if(split1==-1 || split2==-1)
			return null;
		else
			return line.substring(split1+1, split2);
	}
	
	
}
