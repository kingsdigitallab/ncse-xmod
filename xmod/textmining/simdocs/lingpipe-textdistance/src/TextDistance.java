import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.util.ArrayList;
import java.sql.*;
import java.lang.Integer;


import com.aliasi.spell.TfIdfDistance;
import com.aliasi.spell.JaccardDistance;
import com.aliasi.tokenizer.NGramTokenizerFactory;
import com.aliasi.tokenizer.TokenizerFactory;
import com.aliasi.util.Files;

public class TextDistance {
	private static File destDir = null;
	private static File srcDir = null;
	private static String srcPath = null;
	private static int srcPathLen;
	private static File curDir = null;
	private static File infile = null;
	private static File reportRoot = null;
	private static File report1; //file info
	private static OutputStreamWriter outstream1; // writing file info 
	private static boolean oldversion = false;
	private static int fileid = 0;
	private static ArrayList<String> filePath;
	private static TokenizerFactory tokenizerFactory;
	private static TfIdfDistance tfIdf;
	private static JaccardDistance jaccard;
	private static Connection conn = null;
	private static double[][] measure;
	private static int NGRAM_MAX = 6;
	private static int NGRAM_MIN = 2;
	private static char tokDist = '1';


	/**
	 * Parse command line options.
	 */
	private static void parseCommandLine(String[] args){
		int i;
		// iterate over all options (arguments starting with '-')
		try{
			for (i = 0; i < args.length && args[i].charAt(0) == '-'; i++) {
				switch (args[i].charAt(1)) {
				case 'a':
					oldversion = true;
					break;
				case 'b':
					oldversion = false;
					break;
				case 'd':
					destDir = new File(args[++i]);
					break;
				case 's':
					srcDir = new File(args[++i]);
					break;
				case 'i':
					if(oldversion)
						usage();
					infile = new File(args[++i]);
					break;
				case 't':
					tokDist = args[i].charAt(2);
					if (!(tokDist=='1'||tokDist=='2'))
						usage();
					break;
				default:
					//System.err.println("Unrecognised option " + args[i]);
					usage();
				}
			}
		}
		catch(Exception e){
			usage();
		}

	}

	/**
	 * Print a usage message and exit.
	 */
	private static final void usage() {
		System.err.println("Usage:\n"
				+ "-a\tuse old version of the application.\n"
				+ "-b\tuse new version of the application.\n"
				+ "-i\t<input file>\tinput file consisting pairs of files in source directory.\n"
				+ "\tapplicable only for new version.\n"
				+ "-d\t<destination dir> \n"
				+ "-s\t<source dir>\n"
				+ "-t<x>\tx=1:\tTfIdf Distance measure\n"
				+"\tx=2:\tJaccard Distance measure\n"
				+"\tdefault value=1\n"
				);

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
		report1 = new File(reportRoot,"FileNames.txt");
		FileOutputStream fos1 = new FileOutputStream(report1);
		BufferedOutputStream bos1 = new BufferedOutputStream(fos1);
		outstream1 = new OutputStreamWriter(bos1, "ISO-8859-15");
		filePath = new ArrayList<String>();
		traverse(srcDir);
		outstream1.close();
		if(oldversion)
			measureDistance();
		else 
			measureDistance2();
		System.out.println("done");

	}
	/**
	 * Recursive generation and processing of files in a given directory.
	 */

	public void traverse(File f) throws IOException {
		if (f.isDirectory()) {
			//onDirectory(f);
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

		} catch (Exception e) {
			System.out.println(" " + e.getMessage());
		}

	}

	/**
	 * Train for TfIdf distance measure for a file.
	 * 
	 */

	public void onFile(File infile) {
		//String id;
		String s,filename;
		try {
			if(infile.length()> 300 ){
				String dirAbsPath = infile.getAbsolutePath();
				filename = infile.getName();
				filePath.add(fileid, dirAbsPath);
				//id = new Integer(fileid).toString();
				//outstream1.write(id+","+dirAbsPath+"\n");
				//fileid++;
				outstream1.write(filename+"\n");
				System.out.println("Processing document..." + filename);
				
				if (tokDist == '1'){
					s = Files.readFromFile(infile,"ISO-8859-15");
					tfIdf.trainIdf(s);
				}
			}
		} catch (NullPointerException excep) {
			System.out.println(" " + excep.getMessage());
		} catch (Exception e) {
			System.out.println(" " + e.getMessage());
		}

	}
	/**
	 * Writing the term frequency and inverse document frequency of the trained instances.
	 */
/*
	public void measureTermFreq() throws IOException{
		outstream2.write("\nTerm\tDocFreq\tIDF\n");
		for (String term : tfIdf.termSet())
			outstream2.write(term+"\t"+tfIdf.docFrequency(term)+"\t"+tfIdf.idf(term)+"\n");

	}
*/
	/**
	 * Writing Distance measure among files.
	 */

	public void measureDistance() throws IOException{
		
		String f1,f2,s1,s2;
		File infile1,infile2;
		double measure=0.0;
		
		File report2 = new File(reportRoot,"distanceReport.txt");
		FileOutputStream fos2 = new FileOutputStream(report2);
		BufferedOutputStream bos2 = new BufferedOutputStream(fos2);
		OutputStreamWriter outstream2 = new OutputStreamWriter(bos2, "ISO-8859-15");
		int fileCount = filePath.size();
		System.out.println("No of files to be compared:"+fileCount+"\n");
		
		for(int c1=0; c1<fileCount-1;c1++){
			f1 = filePath.get(c1);
			infile1 = new File(f1);
			s1 = Files.readFromFile(infile1,"ISO-8859-15");
			//f1 = new Integer(c1).toString();
			for(int c2=c1+1; c2<fileCount;c2++){
				f2 = filePath.get(c2);
				infile2 = new File(f2);
				s2 = Files.readFromFile(infile2,"ISO-8859-15");
				//f2 = new Integer(c2).toString();
				//measure[c1][c2] = tfIdf.proximity(s1,s2);
				if(tokDist == '1')
					measure = tfIdf.proximity(s1,s2);
				else if(tokDist == '2')
					measure = jaccard.proximity(s1,s2);
				outstream2.write(infile1.getName());
				outstream2.write("\t" + infile2.getName() );
				outstream2.write("\t" + measure +"\n");
				System.out.println("done comparing "+infile1.getName()+" and "+infile2.getName());
			}
		}
		outstream2.close();

	}
	
	/**
	 * Writing Distance measure among files.
	 */

	public void measureDistance2() {
		
		File if1,if2;
		String f[];
		String s1,s2;
		double measure=0.0;
		try{
			File out = new File(reportRoot,infile.getName()+".out");
			FileOutputStream fos = new FileOutputStream(out);
			BufferedOutputStream bos = new BufferedOutputStream(fos);
			OutputStreamWriter outstream = new OutputStreamWriter(bos, "ISO-8859-15");

			String filepairs[] = Files.readLinesFromFile(infile, "ISO-8859-15");
			for (int i=0;i<filepairs.length;i++){
				f = filepairs[i].split("\t");
				if1 = new File(srcDir,f[0] + ".xml");
				if (!if1.exists()){
					System.out.println("File "+f[0] + ".xml"+" doesnt exist.");
					continue;
				}
				s1 = Files.readFromFile(if1,"ISO-8859-15");
				if2 = new File(srcDir,f[1] + ".xml");
				if (!if2.exists()){
					System.out.println("File "+f[1] + ".xml"+" doesnt exist.");
					continue;
				}
				s2 = Files.readFromFile(if2,"ISO-8859-15");
				if(tokDist == '1')
					measure = tfIdf.proximity(s1,s2);
				else if(tokDist == '2')
					measure = jaccard.proximity(s1,s2);
				outstream.write(f[0]);
				outstream.write("\t" + f[1] );
				outstream.write("\t" + measure +"\n");
				System.out.println("done comparing "+f[0]+" and "+f[1]);
			}
			outstream.close();
		}catch(Exception e){
			System.out.println(" " + e.getMessage());
		}
	}

	public void connectDB() {
		
		String url = "jdbc:mysql://localhost:3306/";
		String dbName = "classification";
		String driver = "com.mysql.jdbc.Driver";
		String userName = "root"; 
		String password = "nashila";

		try {
			Class.forName(driver).newInstance();
			conn = DriverManager.getConnection(url+dbName,userName,password);
			System.out.println("Connected to the database");
			
			
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public void insert() {
		String query;
		Statement st;
		int val;
		int fileid1, fileid2;
		String filename;
		
		try{
			int fileCount = filePath.size();
			measure = new double[fileCount][];
			for (int i=0;i<fileCount;i++)
				measure[i] = new double[fileCount];
			for(int c1=0; c1<fileCount;c1++){
				filename = filePath.get(c1);
				query = "INSERT into FileList(Fileid, Filename) VALUES("+c1+",'"+filename+"')";
				st = conn.createStatement();
				val = st.executeUpdate(query);
			}
			//conn.commit();
			System.out.println("File information stored!");
			
			for(fileid1=0; fileid1<fileCount-1;fileid1++){
				
				for(fileid2=fileid1+1; fileid2<fileCount;fileid2++){
					
					query = "INSERT into Proximity(Fileid1, Fileid2,Measure) VALUES("+fileid1+","+fileid2+","+measure[fileid1][fileid2]+")";
					st = conn.createStatement();
					val = st.executeUpdate(query);
					query = "INSERT into Proximity(Fileid1, Fileid2,Measure) VALUES("+fileid2+","+fileid1+","+measure[fileid1][fileid2]+")";
					st = conn.createStatement();
					val = st.executeUpdate(query);
				}
			}
			
			//conn.commit();
			System.out.println("Proximity measures stored!");

		}
		catch (SQLException s){
			System.out.println("SQL statement is not executed!"+s.toString());
		}
	}

	public void closeDB() {
		try {
		conn.close();
		System.out.println("Disconnected from database");
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public TextDistance(String args[]) throws Exception{
		parseCommandLine(args);

	}


	public static void main(String[] args) throws Exception{

		TextDistance app = new TextDistance(args);
		tokenizerFactory = new NGramTokenizerFactory(NGRAM_MIN,NGRAM_MAX);
		if (tokDist == '1')
			tfIdf = new TfIdfDistance(tokenizerFactory);
		else if (tokDist == '2')
			jaccard = new JaccardDistance(tokenizerFactory);
		
		app.process();
		//app.connectDB();
		//app.insert();
		//app.closeDB();

	}
}
