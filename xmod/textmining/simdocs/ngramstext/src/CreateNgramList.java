
import java.io.*;
import java.util.*;
import java.util.regex.Pattern;
import com.aliasi.lm.NGramProcessLM;
import com.aliasi.lm.NGramBoundaryLM;
import com.aliasi.lm.TrieCharSeqCounter;
import com.aliasi.util.ObjectToCounterMap;
import com.aliasi.util.Counter;
import com.aliasi.util.Files;



public class CreateNgramList {

	private static File destDir = null;
	private static File srcDir = null;
	private static String srcPath = null;
	private static int srcPathLen;
	private static File curDir = null;
	private static File reportRoot = null;


	private static int NGRAM_SIZE = 4;
	private static int NGRAM_LOW  = 1;
	private static ObjectToCounterMap<String> map;
	private static ObjectToCounterMap<String> ngramlist = new ObjectToCounterMap<String>();




	/**
	 * Parse command line options.
	 */
	private static void parseCommandLine(String[] args) throws Exception {
		int i;
		// iterate over all options (arguments starting with '-')
		for (i = 0; i < args.length && args[i].charAt(0) == '-'; i++) {
			switch (args[i].charAt(1)) {
			case 'd':
				destDir = new File(args[++i]);
				break;

			case 's':
				srcDir = new File(args[++i]);
				break;

			default:
				System.err.println("Unrecognised option " + args[i]);
			usage();
			}
		}

	}

	/**
	 * Print a usage message and exit.
	 */
	private static final void usage() {
		System.err
		.println("Usage:\n"
				+ "-d type     : destination directory. "
				+ "\n"
				+ "-s type     : source directory."
				+ "\n");

		System.exit(1);
	}
	/**
	 * 
	 * Process Directories one by one.
	 */
	public void process() throws IOException {

		srcPath = srcDir.getAbsolutePath();
		srcPathLen = srcPath.length();
		reportRoot = destDir.getAbsoluteFile();
		curDir = destDir.getAbsoluteFile();
		traverse(srcDir);
		System.out.println("done");

	}

	/**
	 * Recursive generation and processing of files in a given directory.
	 */

	public void traverse(File f) throws IOException {
		if (f.isDirectory()) {
			onDirectory(f);
			File[] children = f.listFiles();
			if (children != null) {
				for (File child : children) {
					traverse(child);
				}
			}
			return;
		}
		onFile(f);
	}

	/**
	 * Creating directory structure in report directory similar to source directory.
	 * 
	 */
	public void onDirectory(File f) {
		try {

			String dirAbsPath = f.getAbsolutePath();
			String dirRelPath = dirAbsPath.substring(srcPathLen + 1);

			boolean success = true;
			if (dirRelPath != "") {
				curDir = new File(reportRoot, dirRelPath);
				success = curDir.mkdir();
				System.out.println("Directory Created..."
						+ curDir.getAbsolutePath());

			}
			if (!success)
				System.out.println("Problem with Directory Creation..."
						+ dirRelPath);
		} catch (Exception e) {
			System.out.println(" " + e.getMessage());
		}

	}

	/**
	 * Main function that process a single file for finding annotations and send
	 * sending it to proper destination files.
	 * 
	 */

	public void onFile(File f) {

		try {
			File infile = f;
			System.out.println("Processing document " + infile);
			String text = Files.readFromFile(infile,"ISO-8859-15");

			NGramProcessLM lm = new NGramProcessLM(NGRAM_SIZE);
			lm.train(text);

			TrieCharSeqCounter tcntr = lm.substringCounter();
			ngramlist.clear();
			for(int i = NGRAM_LOW; i <= NGRAM_SIZE; i++){
				map = tcntr.topNGrams(i, (int)tcntr.uniqueSequenceCount(i));
				map.prune(2);
				format();

			}
			String outputFileName = infile.getName() + ".out";
			File curReportDir = curDir.getAbsoluteFile();
			File outfile = new File(curReportDir, outputFileName);
			FileOutputStream fos = new FileOutputStream(outfile);
			BufferedOutputStream bos = new BufferedOutputStream(fos);
			OutputStreamWriter out = new OutputStreamWriter(bos, "ISO-8859-15");
			out.write(ngramlist.toString());
			out.close();
			

		} catch (NullPointerException excep) {
			System.out.println(" " + excep.getMessage());
		} catch (Exception e) {
			System.out.println(" " + e.getMessage());
		}

	} // for each file
	private static void format(){

		Set keyset = map.keySet();
		for(Iterator it=keyset.iterator();it.hasNext();){
			String key = (String)it.next();
			//System.out.println(key);
			if(Pattern.matches("[ ]*[a-zA-Z_0-9]+[ ]*", key))
				ngramlist.put(key, map.get(key));
		}
		return ;	
	}

	public CreateNgramList(String args[]) throws Exception{
		parseCommandLine(args);

	}

	public static void main(String[] args) throws Exception{

		CreateNgramList app = new CreateNgramList(args);
		app.process();
	}

}
