package uk.ac.kcl.cch.ncse.util;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.util.Set;
import java.util.logging.Level;
import java.util.logging.Logger;

import uk.ac.kcl.cch.ncse.annie.EntityAndBoundingBox;

public class Foo {

	private static Logger LOG = Logger.getLogger(Foo.class.getName());

	private File outFile;
	private BufferedWriter out;

	public Foo(File dir, String filename) {
		try{
			outFile = new File(dir, filename);
			out = new BufferedWriter(new FileWriter(outFile));
		}
		catch(IOException e){
			LOG.log(Level.SEVERE, e.getMessage(), e);
		}
	}

	public void println(String line) {
		try{
			if(line!=null)
				out.write(line);
			out.newLine();
		}
		catch(IOException e){
			LOG.log(Level.SEVERE, e.getMessage(), e);
		}
	}

	public void close() {
		try{
			out.close();
		}
		catch(IOException e){
			LOG.log(Level.SEVERE, e.getMessage(), e);
		}
	}

	public void write(Set<EntityAndBoundingBox> entities, String relativeURL){
		if(entities==null || entities.isEmpty())
			return;
		for(EntityAndBoundingBox eab : entities){
			println(eab.entity+"\t"+relativeURL+"\t"+eab.box);
		}
		try {
			out.flush();
		} 
		catch (IOException e1) {
			e1.printStackTrace();
		}
	}

	public File getFile() {
		return outFile;
	}
	
}
