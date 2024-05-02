package uk.ac.kcl.cch.ncse.frequency;

import java.io.File;
import java.io.IOException;

import uk.ac.kcl.cch.ncse.util.ProcessUtil;

/**
 * Traverses a corpus repository (or part thereof) and generates a frequency list.
 * Executes unix sort in external processes.
 * 
 * @author patrick
 */
public class FrequencyListGenerator {

	public static void main(String[] args) throws IOException, InterruptedException{
		File temp1 = File.createTempFile("freq", ".txt");
		temp1.deleteOnExit();
		File temp2 = File.createTempFile("freqSorted", ".txt");
		temp2.deleteOnExit();
		File temp3 = File.createTempFile("freqSortedCompressed", ".txt");
		temp3.deleteOnExit();
		
		TokenListGenerator t = null;
		if(args.length == 3){
			System.err.println("Reporting unknown tokens only.");
			t = new UnknownTokenListGenerator(new File(args[0]), temp1);
		}
		else
			t = new TokenListGenerator(new File(args[0]), temp1);
		t.processRepository();
		
		Process p1 = Runtime.getRuntime().exec("sort "+temp1.getAbsolutePath()+" -o "+temp2.getAbsolutePath());
		ProcessUtil.drainInBackground(p1);
		p1.waitFor();
		
		TokenListCompressor.compress(temp2, temp3);
		
		File out = new File(args[1]);
		Process p2 = Runtime.getRuntime().exec("sort -n -r "+temp3.getAbsolutePath()+" -o "+out.getAbsolutePath());
		ProcessUtil.drainInBackground(p2);
		p2.waitFor();
	}

	
}
