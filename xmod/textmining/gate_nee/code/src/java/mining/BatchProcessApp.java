/*
 *  BatchProcessApp.java
 *
 *
 * Copyright (c) 2006, The University of Sheffield.
 *
 * This file is part of GATE (see http://gate.ac.uk/), and is free
 * software, licenced under the GNU Library General Public License,
 * Version 2, June1991.
 *
 * A copy of this licence is included in the distribution in the file
 * licence.html, and is also available at http://gate.ac.uk/gate/licence.html.
 *
 *  Ian Roberts, March 2006
 *
 *  $Id: BatchProcessApp.java,v 1.5 2006/06/11 19:17:57 ian Exp $
 */
package mining;

import gate.Document;
import gate.DocumentContent;
import gate.Corpus;
import gate.CorpusController;
import gate.AnnotationSet;
import gate.Annotation;
import gate.Gate;
import gate.Factory;
import gate.util.*;
import gate.util.persistence.PersistenceManager;

import java.util.Set;
import java.util.HashSet;
import java.util.List;
import java.util.ArrayList;
import java.util.Iterator;
import java.io.*;

import org.xml.sax.SAXParseException;

/**
 * This class ilustrates how to do simple batch processing with GATE. It loads
 * an application from a .gapp file (created using "Save application state" in
 * the GATE GUI), and runs the contained application over one or more
 * directories. The results for each annotation types are written out to
 * separate files in the destination directory stated.
 */
public class BatchProcessApp {

	/** Index of the first non-option argument on the command line. */
	private static int firstFile = 0;

	/** Path to the saved application file. */
	private static File gappFile = null;

	/**
	 * List of annotation types to write out. If null, write everything as
	 * GateXML.
	 */
	private static List<String> annotTypesToWrite = null;

	/**
	 * The character encoding to use when loading the documents. If null, the
	 * platform default encoding is used.
	 */
	private static String encoding = null;

	/**
	 * Path to the destination report directory.
	 */
	private static File destDir = null;

	private static File sourceDir = null;
	
	private static String outStyle = "list";

	// load the saved application
	private CorpusController application = null;

	/**
	 * Create a Corpus to use. We recycle the same Corpus object for each
	 * iteration. The string parameter to newCorpus() is simply the
	 * GATE-internal name to use for the corpus. It has no particular
	 * significance.
	 */
	private Corpus corpus = null;

	private static File[] annot_file;

	private static OutputStreamWriter[] out;
	private static OutputStreamWriter outxml1,outxml2,outxml3,outxml4;

	private static int noAnnots;

	private static File reportRoot = null;

	private static String reportPath = null;

	private static String sourcePath = null;

	private static int sourcePathLen;

	private static File curDir = null;

	public BatchProcessApp(String[] arg) {
		try {
			parseCommandLine(arg);
			if (encoding == null)
				encoding = "ISO-8859-15";
			// initialise GATE - this must be done before calling any GATE APIs
			Gate.init();
			application = (CorpusController) PersistenceManager
			.loadObjectFromFile(gappFile);
			corpus = Factory.newCorpus("BatchProcessApp Corpus");
			application.setCorpus(corpus);
		} catch (GateException e) {
			System.out.println(" " + e.getMessage());
		} catch (Exception e) {
			System.out.println(" " + e.getMessage());
		}

	}

	/**
	 * Recursive generation and processing of files in a given directory.
	 */

	public void traverse(File f)  {
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
		try{
		onFile(f);
		}catch(Exception e){
			System.out.println(e.getMessage());
		}
	}
	/**
	 * Creating directory structure in report directory similar to source directory.
	 * 
	 */
	public void onDirectory(File f) {
		try {
			if(!outStyle.equals("xml"))
				return;
			String dirAbsPath = f.getAbsolutePath();
			String dirRelPath = dirAbsPath.substring(sourcePathLen + 1);

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
			File xmlFile = f;
			System.out.print("Processing document " + xmlFile);
			ReadXMLFile docFile = new ReadXMLFile(xmlFile, encoding);

			String docId = docFile.getArticleId();
			String docString = docFile.getArticleText();
			System.out.println("... with id:" + docId);
			

			// if we want to just write out specific annotation types, we must
			// extract the annotations into a Set

			if (annotTypesToWrite != null) {
				
				if(outStyle.equals("list")){
					if (docString.equals("")|| docString.length()<=2 )  {
						System.out.println("done");
						return;
					}
					doReport(docId, docString);
					//doListReport(docId, docString);
					//doPersonXMLReport(docId, docString);
					//doLocationXMLReport(docId, docString);
					//doOrganizationXMLReport(docId, docString);
				}
				else if(outStyle.equals("xml"))
					doXmlReport(xmlFile);

				

			}
			// otherwise, just write out the whole document as GateXML
			else {
				Document docXml = Factory
				.newDocument(xmlFile.toURL(), encoding);
				// put the document in the corpus
				corpus.add(docXml);

				// run the application
				application.execute();

				// remove the document from the corpus again
				corpus.clear();

				String docXMLString = docXml.toXml();
				Factory.deleteResource(docXml);

				createXmlReport(xmlFile, docXMLString);

			}

			System.out.println("done");

		} catch (SAXParseException err) {

			System.out.println(" " + err.getMessage());

		} catch (NullPointerException excep) {
			System.out.println(" " + excep.getMessage());
		} catch (Exception e) {
			System.out.println(" " + e.getMessage());
		}

	} // for each file

	public void doReport(String docId, String docString){
		try {
			Document doc = Factory.newDocument(docString);
			

			// put the document in the corpus
			corpus.add(doc);
			
			// run the application
			application.execute();
			
			// remove the document from the corpus again
			corpus.clear();
			
			// Create a temporary Set to hold the annotations we wish to
			// write out
			Set annotationsToWrite = new HashSet();
			// Set allAnnotationsToWrite = new HashSet();

			// we only extract annotations from the default (unnamed)
			// AnnotationSet
			// in this example
			AnnotationSet defaultAnnots = doc.getAnnotations();
			
			for (int annotInd = 0; annotInd < noAnnots; annotInd++) {
				// extract all the annotations of each requested type and
				// add them to
				// the temporary set
				String annotName = annotTypesToWrite.get(annotInd);
				AnnotationSet annotsOfThisType = defaultAnnots.get(annotName);
				if (annotsOfThisType != null) {
					annotationsToWrite.addAll(annotsOfThisType);
					doListReport(docId,docString,annotInd,annotationsToWrite);
					if(annotName.equals("Person"))
						doPersonXMLReport(docId, docString,annotationsToWrite);
					else if(annotName.equals("Location"))
						doLocationXMLReport(docId, docString,annotationsToWrite);
					else if(annotName.equals("Organization"))
						doOrganizationXMLReport(docId, docString,annotationsToWrite);
					annotationsToWrite.clear();
				}
				
			}
			//System.out.println("write down all..");
			// Release the document, as it is no longer needed
			Factory.deleteResource(doc);
			
		} catch (Exception e) {
			corpus.clear();
			
			System.out.println(" " + e.getMessage());
		}
		
	}
	
	
	/**
	 * Creating list structure of annotation sets.
	 * 
	 */

	
	public void doListReport(String docId, String docString, int annotInd,Set annotationsToWrite) {
			
				// System.out.println("["+annotInd+"]"+annotName);
		try{
				int j = 0;
				for (Iterator defaultIt = annotationsToWrite.iterator(); defaultIt
				.hasNext(); j++) {
					Annotation currAnnot = (Annotation) defaultIt.next();

					int beginIndex = currAnnot.getStartNode().getOffset()
					.intValue();
					int endIndex = currAnnot.getEndNode().getOffset()
					.intValue();
					out[annotInd].write(docString.substring(beginIndex,endIndex)+ "\tDoc ID:" + docId + "\n");
					//out[annotInd].write(currAnnot.getFeatures().get("rule").toString());
					// System.out.println("Annot["+j+"]:"+docString.substring(beginIndex,
					// endIndex));
				}
				
		}catch(Exception e){
			System.out.println(" " + e.getMessage());
		}

	}
	/*
	 * Create XML style report file for Person annotations.
	 */

	public void doPersonXMLReport(String docId, String docString,Set annotationsToWrite) {
		try {
			
			for (Iterator defaultIt = annotationsToWrite.iterator(); defaultIt.hasNext(); ) {

				Annotation currAnnot = (Annotation) defaultIt.next();
				int beginIndex = currAnnot.getStartNode().getOffset().intValue();
				int endIndex = currAnnot.getEndNode().getOffset().intValue();
				String name = docString.substring(beginIndex,endIndex);
				String rule = "",rule1 = "";
				String title="",firstName="", lastName="";
				String tmp;
				if ((tmp = (String)currAnnot.getFeatures().get("rule"))!=null)
					rule = tmp;
				if(rule.equals("PersonFinal")){
					
					String[] names = name.split(" ");
					if ((tmp = (String)currAnnot.getFeatures().get("rule1"))!=null)
						rule1 = tmp;
					if(rule1.equals("PersonFull")){

						if (names.length==2){
							firstName = names[0];
							lastName = names[1];
						}
						else if (names.length>2){
							firstName = names[0];
							lastName = names[names.length-1];
						}	
					}
					else if(rule1.equals("PersonFullReverse")){

						lastName = names[0];
						firstName = names[names.length-1];

					}
					else if(rule1.equals("PersonTitle")||rule1.equals("PersonFirstTitleGender")){

						if (names.length==2){
							title = names[0];
							lastName = names[1];
						}
						else if (names.length>2){
							title = names[0];
							firstName = names[1];
							lastName = names[names.length-1];
						}	
					}
					else if(names.length==1)
						firstName = names[0];

				}

				//outxml.write(currAnnot.toString());
				outxml1.write("<Person>"+"\n");
				outxml1.write("<FullName>"+name.trim()+"</FullName>"+"\n");
				if (!title.equals(""))
					outxml1.write("<Title>"+title+"</Title>"+"\n");
					//System.out.println(title);
				if (!firstName.equals(""))
					outxml1.write("<FirstName>"+firstName.trim()+"</FirstName>"+"\n");
					//System.out.println(firstName);
				if (!lastName.equals(""))
					outxml1.write("<LastName>"+lastName.trim()+"</LastName>"+"\n");
					//System.out.println(lastName);
				outxml1.write("<Rule>"+rule+"</Rule>"+"\n");
				if (!rule1.equals(""))
					outxml1.write("<Rule1>"+rule1+"</Rule1>"+"\n");
				
				outxml1.write("<Doc>"+docId+"</Doc>"+"\n");
				outxml1.write("</Person>"+"\n");

			}
	
		} catch (Exception e) {
			corpus.clear();
			System.out.println(" " + e.getMessage());
		}

	}
	
	/*
	 * Create XML style report file for Person annotations.
	 */

	public void doLocationXMLReport(String docId, String docString,Set annotationsToWrite) {
		try {
			for (Iterator defaultIt = annotationsToWrite.iterator(); defaultIt.hasNext(); ) {

				Annotation currAnnot = (Annotation) defaultIt.next();
				int beginIndex = currAnnot.getStartNode().getOffset().intValue();
				int endIndex = currAnnot.getEndNode().getOffset().intValue();
				String name = docString.substring(beginIndex,endIndex);
				String rule = "",rule2 = "",rule1 = "",locType="";
				String tmp;	
				if ((tmp = (String)currAnnot.getFeatures().get("rule"))!=null)
					rule = tmp;
				if ((tmp = (String)currAnnot.getFeatures().get("rule2"))!=null)
					rule2 = tmp;
				if ((tmp = (String)currAnnot.getFeatures().get("rule1"))!=null)
					rule1 = tmp;
				if ((tmp = (String)currAnnot.getFeatures().get("locType"))!=null)
					locType = tmp;
				
				//outxml.write(currAnnot.toString());
				outxml2.write("<Location>"+"\n");
				outxml2.write("<Name>"+name.trim()+"</Name>"+"\n");
				if (!rule.equals(""))
					outxml2.write("<Rule>"+rule+"</Rule>"+"\n");
				if (!rule2.equals(""))
					outxml2.write("<Rule2>"+rule2+"</Rule2>"+"\n");
				if (!rule1.equals(""))
					outxml2.write("<Rule1>"+rule1+"</Rule1>"+"\n");
				if (!locType.equals(""))
					outxml2.write("<Type>"+locType+"</Type>"+"\n");
				outxml2.write("<Doc>"+docId+"</Doc>"+"\n");
				outxml2.write("</Location>"+"\n");

			}
		
		} catch (Exception e) {
			corpus.clear();
			System.out.println(" " + e.getMessage());
		}

	}
	
	/*
	 * Create XML style report file for Person annotations.
	 */

	public void doOrganizationXMLReport(String docId, String docString,Set annotationsToWrite) {
		try {
				for (Iterator defaultIt = annotationsToWrite.iterator(); defaultIt.hasNext(); ) {

				Annotation currAnnot = (Annotation) defaultIt.next();
				int beginIndex = currAnnot.getStartNode().getOffset().intValue();
				int endIndex = currAnnot.getEndNode().getOffset().intValue();
				String name = docString.substring(beginIndex,endIndex);
				String rule = "",rule2 = "",rule1 = "",orgType="";
				String tmp;	
				if ((tmp = (String)currAnnot.getFeatures().get("rule"))!=null)
					rule = tmp;
				if ((tmp = (String)currAnnot.getFeatures().get("rule2"))!=null)
					rule2 = tmp;
				if ((tmp = (String)currAnnot.getFeatures().get("rule1"))!=null)
					rule1 = tmp;
				if ((tmp = (String)currAnnot.getFeatures().get("orgType"))!=null)
					orgType = tmp;
				
				
				//outxml.write(currAnnot.toString());
				outxml3.write("<Org>"+"\n");
				outxml3.write("<Name>"+name.trim()+"</Name>"+"\n");
				if (!rule.equals(""))
					outxml3.write("<Rule>"+rule+"</Rule>"+"\n");
				if (!rule2.equals(""))
					outxml3.write("<Rule2>"+rule2+"</Rule2>"+"\n");
				if (!rule1.equals(""))
					outxml3.write("<Rule1>"+rule1+"</Rule1>"+"\n");
				if (!orgType.equals(""))
					outxml3.write("<Type>"+orgType+"</Type>"+"\n");
				outxml3.write("<Doc>"+docId+"</Doc>"+"\n");
				outxml3.write("</Org>"+"\n");


			}
			} catch (Exception e) {
			corpus.clear();
			System.out.println(" " + e.getMessage());
		}

	}
	/**
	 * Creating XML file structure of annotation sets.
	 * 
	 */

	public void doXmlReport(File xmlFile) {
		try {
			Document doc = Factory.newDocument(xmlFile.toURL(), encoding);

			// put the document in the corpus
			corpus.add(doc);

			// run the application
			application.execute();

			// remove the document from the corpus again
			corpus.clear();
			// Create a temporary Set to hold the annotations we wish to
			// write out
			String docXMLString = null;
			Set allAnnotationsToWrite = new HashSet();

			// we only extract annotations from the default (unnamed)
			// AnnotationSet
			// in this example
			AnnotationSet defaultAnnots = doc.getAnnotations();

			for (int annotInd = 0; annotInd < noAnnots; annotInd++) {
				// extract all the annotations of each requested type and
				// add them to
				// the temporary set
				String annotName = annotTypesToWrite.get(annotInd);
				AnnotationSet annotsOfThisType = defaultAnnots.get(annotName);
				
				if (annotsOfThisType != null)
					allAnnotationsToWrite.addAll(annotsOfThisType);

			}

			// create the XML string using these annotations
			docXMLString = doc.toXml(allAnnotationsToWrite);
			// Release the document, as it is no longer needed
			Factory.deleteResource(doc);
			createXmlReport(xmlFile, docXMLString);
		} catch (Exception e) {
			System.out.println(" " + e.getMessage());
		}

	}

	/**
	 * Creating xml file for the xml structured annotations.
	 * 
	 */

	public void createXmlReport(File xmlFile, String docXMLString) {

		try {
			// output the XML to <inputFile>.out.xml
			String outputFileName = xmlFile.getName() + ".out.xml";
			File curReportDir = curDir.getAbsoluteFile();

			File outputFile = new File(curReportDir, outputFileName);

			// Write output files using the same encoding as the original
			FileOutputStream fos = new FileOutputStream(outputFile);
			BufferedOutputStream bos = new BufferedOutputStream(fos);
			OutputStreamWriter outxml;

			outxml = new OutputStreamWriter(bos, encoding);

			outxml.write(docXMLString);

			outxml.close();
		} catch (Exception e) {
			System.out.println(" " + e.getMessage());
		}

	}

	/**
	 * Parse command line options.
	 */
	private static void parseCommandLine(String[] args) throws Exception {
		int i;
		// iterate over all options (arguments starting with '-')
		for (i = 0; i < args.length && args[i].charAt(0) == '-'; i++) {
			switch (args[i].charAt(1)) {
			// -a type = write out annotations of type a.
			case 'a':
				if (annotTypesToWrite == null)
					annotTypesToWrite = new ArrayList();
				annotTypesToWrite.add(args[++i]);
				break;

				// -g gappFile = path to the saved application
			case 'g':
				gappFile = new File(args[++i]);
				break;

				// -e encoding = character encoding for documents
			case 'e':
				encoding = args[++i];
				break;

			case 'd':
				destDir = new File(args[++i]);
				break;
				
			case 'c':
				outStyle = args[++i];
				break;

			default:
				System.err.println("Unrecognised option " + args[i]);
				usage();
			}
		}

		// set index of the first non-option argument, which we take as the
		// first
		// file to process
		firstFile = i;

		// sanity check other arguments
		if (gappFile == null) {
			System.err.println("No .gapp file specified");
			usage();
		}
	}

	/**
	 * Print a usage message and exit.
	 */
	private static final void usage() {
		System.err
		.println("Usage:\n"
				+ "   java sheffield.examples.BatchProcessApp -g <gappFile> [-e encoding]\n"
				+ "            [-a annotType] [-a annotType] file1 file2 ... fileN\n"
				+ "\n"
				+ "-g gappFile : (required) the path to the saved application state we are\n"
				+ "              to run over the given documents.  This application must be\n"
				+ "              a \"corpus pipeline\" or a \"conditional corpus pipeline\".\n"
				+ "\n"
				+ "-e encoding : (optional) the character encoding of the source documents.\n"
				+ "              If not specified, the platform default encoding (currently\n"
				+ "              \""
				+ System.getProperty("file.encoding")
				+ "\") is assumed.\n"
				+ "\n"
				+ "-a type     : (optional) write out just the annotations of this type as\n"
				+ "              inline XML tags.  Multiple -a options are allowed, and\n"
				+ "              annotations of all the specified types will be output.\n"
				+ "              This is the equivalent of \"save preserving format\" in the\n"
				+ "              GATE GUI.  If no -a option is given the whole of each\n"
				+ "              processed document will be output as GateXML (the equivalent\n"
				+ "              of \"save as XML\")."
				+ "\n"
				+ "-d type     : the path to the destination where report will be stored. "
				+ "\n"
				+ "-c type     : (optional) the style how the output will be shown.\n"
				+ "              list: list format\n"
				+ "              xml: XML format\n"
				+ "\n");

		System.exit(1);
	}

	/**
	 * Initialize different files and streams.
	 * 
	 */

	public void fileInit() {
		
		try {
			reportRoot = destDir.getAbsoluteFile();
			curDir = destDir.getAbsoluteFile();
			noAnnots = annotTypesToWrite.size();
			if(outStyle.equals("xml"))
				return;

			annot_file = new File[annotTypesToWrite.size()];
			out = new OutputStreamWriter[annotTypesToWrite.size()];

			

			if (annotTypesToWrite != null) {

				for (int annotInd = 0; annotInd < noAnnots; annotInd++) {
					String annotName = annotTypesToWrite.get(annotInd);
					annot_file[annotInd] = new File(reportRoot, annotName
							+ ".txt");

					FileOutputStream fos = new FileOutputStream(
							annot_file[annotInd]);
					BufferedOutputStream bos = new BufferedOutputStream(fos);
					out[annotInd] = new OutputStreamWriter(bos, encoding);

				}
			}
			
			File outputFile1 = new File(reportRoot, "Person.lst.xml");
			File outputFile2 = new File(reportRoot, "Location.lst.xml");
			File outputFile3 = new File(reportRoot, "Org.lst.xml");
			// Write output files using the same encoding as the original
			FileOutputStream fos1 = new FileOutputStream(outputFile1);
			FileOutputStream fos2 = new FileOutputStream(outputFile2);
			FileOutputStream fos3 = new FileOutputStream(outputFile3);
			
			BufferedOutputStream bos1 = new BufferedOutputStream(fos1);
			BufferedOutputStream bos2 = new BufferedOutputStream(fos2);
			BufferedOutputStream bos3 = new BufferedOutputStream(fos3);
			
			outxml1 = new OutputStreamWriter(bos1, encoding);
			outxml1.write("<?xml version=\"1.0\" encoding=\"ISO-8859-15\" ?>"+"\n");
			outxml1.write("<PERSONDATA>"+"\n");
			outxml2 = new OutputStreamWriter(bos2, encoding);
			outxml2.write("<?xml version=\"1.0\" encoding=\"ISO-8859-15\" ?>"+"\n");
			outxml2.write("<LOCATIONDATA>"+"\n");
			outxml3 = new OutputStreamWriter(bos3, encoding);
			outxml3.write("<?xml version=\"1.0\" encoding=\"ISO-8859-15\" ?>"+"\n");
			outxml3.write("<ORGDATA>"+"\n");
			
		} catch (FileNotFoundException e) {
			System.out.println(" " + e.getMessage());
		} catch (UnsupportedEncodingException e) {
			System.out.println(" " + e.getMessage());
		} catch (Exception e) {
			System.out.println(" " + e.getMessage());
		}
	}

	/**
	 * Close streams.
	 * 
	 */

	public void fileClose() throws IOException {
		System.out.println("All done");
		if(outStyle.equals("xml"))
			return;
		for (int k = 0; k < noAnnots; k++) {
			out[k].close();
		}
		outxml1.write("</PERSONDATA>"+"\n");
		outxml1.close();
		outxml2.write("</LOCATIONDATA>"+"\n");
		outxml2.close();
		outxml3.write("</ORGDATA>"+"\n");
		outxml3.close();
		

	}

	/**
	 * 
	 * Process Directories one by one.
	 */

	public void process(String[] args) throws IOException {

		for (int i = firstFile; i < args.length; i++) {

			sourceDir = new File(args[i]);
			sourcePath = sourceDir.getAbsolutePath();
			sourcePathLen = sourcePath.length();
			traverse(sourceDir);

		}

	}

	public static void main(String[] args) throws Exception {

		BatchProcessApp app = new BatchProcessApp(args);
		app.fileInit();
		app.process(args);
		app.fileClose();

	}
}
